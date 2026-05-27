param (
    [string[]]$ConfigNames
)

Write-Host "Config names: $ConfigNames"

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

$ConfigDirPaths = @((Join-Path $PSScriptRoot 'config'))
$ConfigCommands = @()
foreach ($ConfigName in $ConfigNames) {
    $ConfigFileName = $ConfigName + '.json'
    $ConfigFilePath = Find-ConfigFile $ConfigDirPaths $ConfigFileName
    if ([string]::IsNullOrWhiteSpace($ConfigFilePath)) {
        Write-Error "Couldn't find config with name ${ConfigName}"
    } else {
        Write-Output $ConfigFilePath
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
        
        Default { Write-Output "unknown command $CommandType" }
    }
}