
Param
(
    [Parameter(Mandatory = $true, Position = 0)]
    [string] $origin,
    [Parameter(Mandatory = $true, Position = 1)]
    [string] $destination
)

$newFolder = "C:\temp"

Function RemoveFolderIfExists($folderPath ) {
    If (Test-Path -Path $folderPath) {
        Write-Host "The folder $folderPath exists. Removing it..."
        Remove-Item $folderPath -Force
    }
}

Function CreateNewFolder($folderPath ) {
    if (!(Test-Path $folderPath)) {
        Write-Host "Creating the new folder: $folderPath"
        New-Item -ItemType Directory -Path $folderPath | Out-Null
    }
}

Function CheckoutBranch($branch) {
    Write-Host "Checking if the Git branch $branch exists..."

    $Result = git checkout $branch

    if ($Result -match 'error') {
        Write-Host "branch $branch was NOT Found!"

        return $false
    }

    return $true
}

$date = get-date -Format "yyyyMMdd_HHmmsss"

$newFolder = $newFolder + "\" + $date

RemoveFolderIfExists($newFolder)
CreateNewFolder($newFolder)

Set-Location $newFolder

$env:GIT_REDIRECT_STDERR = '2>&1'

Invoke-Expression "git -c http.sslVerify=false clone $origin"

$subFolder = Get-ChildItem -Directory $newFolder

Set-Location $subFolder

Write-Host "Getting the list of Git branches from the origin Repository..."

$gitBranches = git for-each-ref --format='%(refname:short)' refs/remotes/origin `
| Where-Object { $_ -ne 'origin/HEAD' } `
| ForEach-Object { $_ -replace '^origin/', '' }

foreach ($branch in $gitBranches) {
    if ($branch -eq "origin") {
        continue
    }

    Write-Host "Cloning Branch: " $branch

    if (CheckoutBranch($branch) -eq true) {
        Invoke-Expression "git config --global http.sslVerify false"
        Invoke-Expression "git clone --mirror $destination"
        Invoke-Expression "git push --mirror $destination"
    }
}

Set-Location $PSScriptRoot
