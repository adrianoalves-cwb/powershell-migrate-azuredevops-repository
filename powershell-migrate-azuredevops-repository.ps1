Param
(
    [Parameter(Mandatory = $true, Position = 0)]
    [string] $Origin,

    [Parameter(Mandatory = $true, Position = 1)]
    [string] $Destination
)

$TempFolderPath = "C:\temp"

$date = Get-Date -Format "yyyyMMdd_HHmmss"
$newFolder = Join-Path $TempFolderPath $date

if (Test-Path $newFolder) {
    Remove-Item $newFolder -Recurse -Force
}

New-Item -Path $newFolder -ItemType Directory | Out-Null
Set-Location $newFolder

git -c http.sslVerify=false clone --mirror $Origin
$repoFolder = Get-ChildItem -Path $newFolder -Directory | Select-Object -First 1
Set-Location $repoFolder.FullName

git remote set-url --push origin $Destination
git push --mirror