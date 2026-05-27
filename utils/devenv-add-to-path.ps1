$PathScope = 'Machine'

$MachinePath = [Environment]::GetEnvironmentVariable('Path', $PathScope)
$paths = $MachinePath -split ';' | Where-Object { $_ -ne '' }

$FolderAddToPath = Join-Path -Resolve $PSScriptRoot ".."
if ($paths -notcontains $FolderAddToPath) {
    $NewPathValue = ($paths + $FolderAddToPath) -join ';'
    [Environment]::SetEnvironmentVariable('Path', $NewPathValue, $PathScope)
    Write-Output "System PATH environment variable was updated"
}
else {
    Write-Output "System PATH environment variable already contains ${FolderAddToPath}"
}