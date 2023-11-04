# pwsh.exe -nologo -- remove pwsh version

[console]::InputEncoding = [console]::OutputEncoding = New-Object System.Text.UTF8Encoding
$PSDefaultParameterValues['Out-File:Encoding'] = 'utf8'
$PSDefaultParameterValues['*:Encoding'] = 'utf8'

Import-Module Terminal-Icons # Install-Module -Name Terminal-Icons

function Export ($PathToAdd){
	$existingPath = [Environment]::GetEnvironmentVariable('Path', 'User')
	($existingPath -notlike "*$PathToAdd*") -and [Environment]::SetEnvironmentVariable('Path', $env:Path + ";" + $PathToAdd, 'User')
}

function GlobalExport ($PathToAdd){
	$existingPath = [Environment]::GetEnvironmentVariable('Path', 'Machine')
	($existingPath -notlike "*$PathToAdd*") -and [Environment]::SetEnvironmentVariable('Path', $env:Path + ";" + $PathToAdd, 'Machine')
}

Export 'C:\Users\rafae\scoop\apps\scoop\current\bin' > $null
Export 'C:\Users\rafae\scoop\shims' > $null

# Needs admin privileges
# Runs only if the varible not exist
$env:GIT_EDITOR -or [Environment]::SetEnvironmentVariable('GIT_EDITOR', 'C:\\Users\\rafae\\scoop\\shims\\nvim.exe', 'Machine') >$null
$env:SCOOP -or [Environment]::SetEnvironmentVariable('SCOOP', 'C:\Users\rafae\scoop' , 'Machine') >$null
$env:SCOOP_GLOBAL -or [Environment]::SetEnvironmentVariable('SCOOP_GLOBAL', 'C:\Users\rafae\scoopg', 'Machine') >$null

Set-PSReadLineOption -EditMode Emacs
Set-PSReadLineKeyHandler -Chord 'Ctrl+d' -Function DeleteChar
Set-PSReadLineOption -PredictionSource History
Set-PSReadLineOption -BellStyle None

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

function st () {
	$originalDir = Get-Location
	$dirs = Get-ChildItem -Path . | Where-Object { $_.PSIsContainer }
	foreach ($dir in $dirs) {
		Set-Location $dir.FullName
		Write-Host $dir.BaseName -ForegroundColor green
		git status
	}

	Set-Location $originalDir
}

function sup () {
	scoop update *
	scoop update bucket *
	scoop cleanup *
	scoop status
}

function prompt {
  $Host.UI.RawUI.WindowTitle = ($pwd | Split-Path -Leaf)
	$(if (Test-Path variable:/PSDebugContext) { '[DBG]: ' }
		else { '' }) + $(Split-Path -Path (Get-Location) -Leaf) +
	$(if ($NestedPromptLevel -ge 1) { '>>' }) + ' 󰁕 '
}

Set-Alias ll ls
Set-Alias v nvim
Set-Alias vim nvim
Set-Alias which where.exe
Set-Alias mv Rename-Item
Set-Alias touch New-Item
Set-Alias scmds Show-Command
Set-Alias g git
Set-Alias grep findstr
Set-Alias tig 'tig.exe'
Set-Alias less 'less.exe'

Set-PSReadLineKeyHandler -Chord "Alt+l" -Function AcceptSuggestion
Set-PSReadLineKeyHandler -Chord "Ctrl+LeftArrow" -Function BackwardWord
Set-PSReadLineKeyHandler -Chord "Ctrl+RightArrow" -Function NextWord
Set-PSReadLineKeyHandler -Chord "Ctrl+a" -Function SelectAll
Set-PSReadLineKeyHandler -Chord "Alt+w" -Function KillWord
Set-PSReadLineKeyHandler -Chord "Ctrl+Alt+d" -Function KillLine


function ide {
  start wt 'sp -H -s 0.30'
  Start-Sleep -Seconds 0.2
  start wt 'sp -V -s 0.65'
  Start-Sleep -Seconds 0.2
  start wt 'sp -V -s 0.5'
  Start-Sleep -Second 0.2
}
