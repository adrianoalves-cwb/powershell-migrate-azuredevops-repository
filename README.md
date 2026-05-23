# PowerShell - Migrate Azure DevOps Repository

This script mirrors a Git repository from one remote URL to another.

## Script

- powershell-migrate-azuredevops-repository.ps1

## What It Does

The script:

1. Receives two mandatory parameters:
   - Origin: source repository URL
   - Destination: target repository URL
2. Creates a timestamped temporary folder under C:\temp.
3. Runs a mirror clone from the source repository.
4. Updates the push URL for origin to the destination repository.
5. Pushes all refs with --mirror.

## Requirements

- Windows with PowerShell.
- Git installed and available in PATH.
- Access permissions to both source and destination repositories.

## Usage

Run from PowerShell:

```powershell
.\powershell-migrate-azuredevops-repository.ps1 -Origin "https://dev.azure.com/ORG/PROJECT/_git/SOURCE_REPO" -Destination "https://dev.azure.com/ORG/PROJECT/_git/TARGET_REPO"
```

## Parameters

- Origin (string, required): Source repository URL.
- Destination (string, required): Destination repository URL.

## Example

```powershell
.\powershell-migrate-azuredevops-repository.ps1 -Origin "https://dev.azure.com/my-org/MyProject/_git/repo-a" -Destination "https://dev.azure.com/my-org/MyProject/_git/repo-b"
```

## Notes and Caution

- The script uses:

```bash
git -c http.sslVerify=false clone --mirror <origin>
```

This disables SSL certificate verification during clone. Use with caution and only in trusted environments.

- The command below pushes all refs (branches, tags, notes, and remote-tracking refs):

```bash
git push --mirror
```

Ensure the destination repository is the correct target before running.

- Temporary working folder is created in C:\temp with a timestamp name.
