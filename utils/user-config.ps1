function Write-DefaultUserConfig {
    param (
        [Parameter(Mandatory=$true)]
        [string]$UserConfigFile
    )

    $DefaultConfig = [pscustomobject]@{
        'ConfigPaths' = @(
            '$<DEVENV_DIR>/config',
            '$<USER_HOME_DIR>/AppData/Local/devshell/config'
        )
    }

    $DefaultConfigDirtyJson = ($DefaultConfig | ConvertTo-Json -Compress)
    $DefaultConfigJson = ([Regex]::Unescape($DefaultConfigDirtyJson))

    $DefaultConfigJson > $UserConfigFile
}