  <#
.SYNOPSIS
Creates several folders to store threat hunting investigation data in.

.DESCRIPTION
Creates a named and timestamped folder for threat hunting investigations.
<name>_notes.md is created to hold all threat hunting notes.

Adds the following subfolders: 
"EDR" - Artifacts from endpoint detection and response tools
"SIEM" - Artifacts from a SIEM
"Host_Logs" - Stores logs extracted from the host
"Media" - Stores screenshots, images, pdfs or other various related artifacts.
"Diagrams" - Stores architecture or information flow diagrams

.PARAMETER Name
Name of the directory to be created. The script will append the name of the directory in the 
following format <name>_date

.EXAMPLE
.\New-Investigation-Dir.ps1 -Name CriticalInfra   

#>
param(
    # Name of the folder to be created
    [Parameter(Mandatory=$True)]
    [String]
    $Name
)

# Create a timestamped folder
$hunt_folder = Join-Path -Path $pwd -ChildPath "$(Get-Date -UFormat "%m_%d_%y")_$Name"

# Check if folder already exists
if (Test-Path $hunt_folder) {
    Write-Error "Folder '$hunt_folder' already exists. Script stopping."
    return
}

# Create the folder with error handling
$ErrorActionPreference = 'Stop'
try {
    New-Item -Path $hunt_folder -ItemType Directory -ErrorAction Stop
} catch {
  Write-Error "'$hunt_folder' Creation failed. Error: $($_.Exception.Message)"
    return
} finally {
    $ErrorActionPreference = 'Continue'
}


# Create investigation subfolders
$subfolders = "EDR", "SIEM", "Host_Logs", "Media", "Diagrams","Intel"
foreach ($f in $subfolders){
    $subfolder_path = Join-Path -Path $hunt_folder -ChildPath $f
    New-Item -Path $subfolder_path -ItemType Directory -Force
}

# Create a notes folder
$hunt_notes = Join-Path -Path $hunt_folder -ChildPath "$Name`_notes.md"

$notes_content = @"
# Hypothesis
$(Get-Date)

# Analysis

# Recommendation

# Remediation

# Details

## Alerts

## Hosts

## Users

## Files

## Network

## Analytics

"@

New-Item -Path $hunt_notes -ItemType File
Set-Content $hunt_notes $notes_content