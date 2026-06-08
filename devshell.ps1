param (
    [string[]]$ConfigNames
)

Write-Output "*************************************************************************"
Write-Output "**************************** DevShell v0.1.0 ****************************"
Write-Output "*************************************************************************"

$UtilsDirName = 'utils'
$UtilsDirPath = Join-Path $PSScriptRoot $UtilsDirName
if (-not (Test-Path -Path $UtilsDirPath)) {
    Write-Error "Internal Error. Reinstall utility"
    exit 100
}

$MainUtilsFileName = 'main-utils.ps1'
$MainUtilsFilePath = Join-Path $UtilsDirPath $MainUtilsFileName
if (-not (Test-Path -Path $MainUtilsFilePath)) {
    Write-Error "Internal Error. Reinstall utility"
    exit 101
}

. $MainUtilsFilePath

$UserConfigFilePath = (Find-UserConfigFile)
if ([string]::IsNullOrWhiteSpace($UserConfigFilePath)) {
    Write-Error "Couldn't find user config .devshell.conf - reinstall utility to fix this problem"
    exit 102
}


$Variables = @{
    'DEVENV_DIR' = (Reverse-Backslashes $PSScriptRoot)
    'USER_HOME_DIR' = (Reverse-Backslashes $HOME)
}

$UserConfig = (Get-Content -Path $UserConfigFilePath -Raw | ConvertFrom-Json)
if ($null -ne $UserConfig.Variables) {
    $Variables += $UserConfig.Variables
} 

Write-Output ("-" * 75)
Write-Output ("Configs: " + $ConfigNames -join ', ') 
Write-Output ("-" * 75)

$ConfigDirectories = @()
foreach ($ConfigPath in $UserConfig.ConfigPaths) {
    $dir = (ReplaceVariables -Variables $Variables -OriginalString $ConfigPath)

    $ConfigDirectories += $dir
}

$ConfigCommands = @()
foreach ($ConfigName in $ConfigNames) {
    $ConfigFileName = $ConfigName + '.json'
    $ConfigFilePath = Find-ConfigFile $ConfigDirectories $ConfigFileName
    if ([string]::IsNullOrWhiteSpace($ConfigFilePath)) {
        Write-Error "Couldn't find config with name ${ConfigName}"
    } else {
        $ConfigCommands += (Parse-ConfigFile -ConfigFilePath $ConfigFilePath)
    }
}

foreach ($Command in $ConfigCommands) {
    $CommandType = $Command.type
    switch ($CommandType) {
        { $_ -eq 'add' } {
            $EnvName = $command.envname
            $EnvValue = $command.envvalue

            Write-Output "Add new variable: $EnvName = $EnvValue"
            Set-Item -Path "Env:$EnvName" -Value $EnvValue

            break;
        }
        { $_ -eq 'update'} {
            $EnvName = $command.envname
            $EnvValue = $command.envvalue

            $PreviousValue = (Get-Item -Path "Env:$EnvName").Value
            $PreviousValues = $PreviousValue -split ";"
            $NewValues = $PreviousValues
            $NewValues += $EnvValue

            $NewValue = $NewValues -join ";"

            Write-Output "Update variable ${EnvName}: add $EnvValue"
            Set-Item -Path "Env:${EnvName}" -Value $NewValue
        }
        
        Default { Write-Warning "unknown command $CommandType" }
    }
}