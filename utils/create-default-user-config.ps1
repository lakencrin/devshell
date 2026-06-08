. (Join-Path $PSScriptRoot 'user-config.ps1')
. (Join-Path $PSScriptRoot 'main-utils.ps1')

Write-DefaultUserConfig -UserConfigFile (Get-UserConfigFilePath)