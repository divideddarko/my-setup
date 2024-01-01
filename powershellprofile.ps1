oh-my-posh --init --shell pwsh --config "$env:POSH_THEMES_PATH\dracula.omp.json" | Invoke-Expression

Import-Module -Name Terminal-Icons
Import-Module -Name PSReadLine

Set-PSReadLineOption -PredictionSource History
Set-PSReadLineOption -PredictionViewStyle ListView
Set-PSReadLineOption -EditMode Windows
Set-Alias n nvim


function Get-PublicIP {
	((Invoke-WebRequest -Uri http:\\www.ifconfig.com).Content).Split("Your IP is")[1].Split("<br>")[0]
}

function Split-CSV {
	param(
		[Parameter(Mandatory = $true)]
		[String]$CSVFile,
		[Parameter(Mandatory = $true)]
		[String]$outputFileName,
		[String]$outputPath = (Get-Location),
		[int]$splitNumber = "100"
	)

	Write-Host "Importing $CSVFile"

	$importedCSV = Import-Csv $CSVFile
	$fileCounter = 0

	for ($count = 0; $count -lt $importedCSV.length; $count++){
		if($count%$($splitNumber) -eq 0){
			$fileCounter++
		}
		$importedCSV[$count] | Export-Csv "$($outputPath)/$($outputFileName)-$($fileCounter).csv" -Append
	}

	Write-Host "$fileCounter" -NoNewline -ForegroundColor Green
	Write-Host " csv files created - " -NoNewline
	Write-Host "$($outputPath)" -ForegroundColor Blue
}

# Import the Chocolatey Profile that contains the necessary code to enable
# tab-completions to function for `choco`.
# Be aware that if you are missing these lines from your profile, tab completion
# for `choco` will not function.
# See https://ch0.co/tab-completion for details.
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
  Import-Module "$ChocolateyProfile"
}

function New-AOCFolder {
  Write-Host "Creating a new folder and subfolder for Advent of Code $(Get-Date -f yyyy)" -ForegroundColor Blue

  $folderDetails = New-Item -Path "$($env:USERPROFILE)\Documents\Programming\AdventOfCode\" -Name "$(Get-Date -f yyyy)" -Type Directory

  if ($folderDetails.Exists) {
    1 .. 25 | ForEach-Object {
      $dayFolders = New-Item -Path "$($folderDetails.FullName)\" -Name "Day$($_)" -Type Directory
      if ($dayFolders.Exists) {
	New-Item -Type File -Path "$($dayFolders.FullName)\testinput.txt"
	New-Item -Type File -Path "$($dayFolders.FullName)\input.txt"
	New-Item -Type File -Path "$($dayFolders.FullName)\solution.ps1"
      }
    }
  }
  Write-Host "AOC folders have been created" -ForegroundColor Green
}
