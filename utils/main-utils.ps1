function Parse-ConfigFile {
    param (
        [string]$ConfigFilePath
    )

    if ([string]::IsNullOrWhiteSpace($ConfigFilePath) -or -not (Test-Path -Path $ConfigFilePath)) {
        throw [System.ArgumentException]"Config file path is not valid."
    }

    $ConfigRaw = Get-Content -Path $ConfigFilePath -Raw | ConvertFrom-Json
    $ConfigCommands = $ConfigRaw.commands
    return $ConfigCommands
}

function Find-ConfigFile {
    param (
        [string[]]$ConfigDirPaths,
        [string]$ConfigFileName
    )

    foreach ($ConfigDirPath in $ConfigDirPaths) {
        $ConfigFilePath = Join-Path $ConfigDirPath $ConfigFileName
        if (Test-Path -Path $ConfigFilePath) {
            return (Convert-Path (Resolve-Path $ConfigFilePath))
        }
    }

    return ""
}