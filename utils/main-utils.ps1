function Get-UserConfigFilePath {
    return (Join-Path $HOME '.devshell.conf')
}

function Find-UserConfigFile {
    $UserConfigFile = (Get-UserConfigFilePath)
    if (-not (Test-Path $UserConfigFile)) {
        return
    }

    return $UserConfigFile
}

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

function Reverse-Backslashes {
    param (
        [string]$OriginalPath
    )

    return ($OriginalPath -replace '\\', '/')
}

function ReplaceVariables {
    param (
        [System.Collections.Hashtable]$Variables,
        [string]$OriginalString
    )

    $result = $OriginalString
    foreach ($var in $Variables.GetEnumerator()) {
        $result = $result -creplace ("\$\<" + $var.Key + "\>"), $var.Value
    }

    return $result
}