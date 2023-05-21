# set PowerShell to UTF-8
[console]::InputEncoding = [console]::OutputEncoding = New-Object System.Text.UTF8Encoding
$PSDefaultParameterValues['Out-File:Encoding'] = 'utf8'
$PSDefaultParameterValues['*:Encoding'] = 'utf8'

# Modules
Import-Module -Name PSColor # https://github.com/Davlind/PSColor
## remove `Write-Host ""` from the source code, the main repo is not maintained anymore - 19/05/2023

# Function aliases

function lla () {
	Get-ChildItem
	Get-ChildItem -h
}

function ll () {
  Get-ChildItem -Path . -Exclude ".*"
}

function pall () {
	$dirs = Get-ChildItem -Path . | Where-Object { $_.PSIsContainer }
	$back = Get-Location
	foreach ($dir in $dirs) {
		Set-Location $dir.FullName
		Write-Output $dir.FullName
		git pull origin
	}
	Set-Location $back.Path
}

function stall () {
	$originalDir = Get-Location
	$dirs = Get-ChildItem -Path . | Where-Object { $_.PSIsContainer }
	foreach ($dir in $dirs) {
		Set-Location $dir.FullName
		Write-Host $dir.BaseName -ForegroundColor green
		git status
	}

	Set-Location $originalDir
}

function upall () {
	scoop update *
	scoop update bucket *
	scoop cleanup *
	scoop status
}

Set-Alias vim nvim
Set-Alias which where.exe
Set-Alias mv Rename-Item
Set-Alias touch New-Item
Set-Alias scmds Show-Command
Set-Alias g git
Set-Alias st status
Set-Alias s scoop
Set-Alias uns uninstall

