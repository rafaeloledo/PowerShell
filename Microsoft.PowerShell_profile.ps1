# set PowerShell to UTF-8
[console]::InputEncoding = [console]::OutputEncoding = New-Object System.Text.UTF8Encoding
$PSDefaultParameterValues['Out-File:Encoding'] = 'utf8'
$PSDefaultParameterValues['*:Encoding'] = 'utf8'

function lla () {
	Get-ChildItem
	Get-ChildItem -h
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

function statusall () {
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

# change the behavior of duplicate terminal tab to open in the same cwd
# https://learn.microsoft.com/en-us/windows/terminal/tutorials/new-tab-same-directory
function prompt {
	$loc = $($executionContext.SessionState.Path.CurrentLocation);
	$out = "PS $loc$('>' * ($nestedPromptLevel + 1)) ";
	$out += "$([char]27)]9;9;`"$loc`"$([char]27)\"
	return $out
}

Set-Alias vim nvim
Set-Alias which where.exe
Set-Alias rename Rename-Item
Set-Alias touch New-Item
Set-Alias scmds Show-Command
Set-Alias ll ls
Set-Alias g git
Set-Alias st status
Set-Alias s scoop
Set-Alias uns uninstall