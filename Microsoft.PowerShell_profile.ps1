# pwsh.exe -nologo -- remove pwsh version

[console]::InputEncoding = [console]::OutputEncoding = New-Object System.Text.UTF8Encoding
$PSDefaultParameterValues['Out-File:Encoding'] = 'utf8'
$PSDefaultParameterValues['*:Encoding'] = 'utf8'

Import-Module Terminal-Icons
Import-Module PSFzf
Import-Module PsFzfUtil

function Export ($PathToAdd) {
	$existingPath = [Environment]::GetEnvironmentVariable('Path', 'User')
	($existingPath -notlike "*$PathToAdd*") -and [Environment]::SetEnvironmentVariable('Path', $env:Path + ";" + $PathToAdd, 'User')
}

function GlobalExport ($PathToAdd) {
	$existingPath = [Environment]::GetEnvironmentVariable('Path', 'Machine')
	($existingPath -notlike "*$PathToAdd*") -and [Environment]::SetEnvironmentVariable('Path', $env:Path + ";" + $PathToAdd, 'Machine')
}

# Just for registering the Exports, run this only one time in the cli
# Export 'C:\scoop\apps\scoop\current\bin' > $null
# Export 'C:\Users\rafae\AppData\Local\Obsidian' > $null
# Export 'C:\scoop\shims' > $null

Set-PSReadLineKeyHandler -Chord 'Ctrl+d' -Function DeleteChar
Set-PSReadLineOption -EditMode Emacs
Set-PSReadLineOption -PredictionSource History
Set-PSReadLineOption -BellStyle None
Set-PSReadLineOption -PredictionViewStyle ListView
Set-PSReadLineKeyHandler -Key Tab -ScriptBlock { Invoke-FzfTabCompletion }

Remove-Alias cat 2>&1>$null
function cat ($parameter) {
	bat --plain --color=always $parameter
}

# git pull on all children repos
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

# git status from all children repos
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

function celular () {
  scrcpy --disable-screensaver --turn-screen-off
}

function tree {
  eza --tree --git-ignore
}

Set-Alias vim 'C:\scoop\apps\neovim\current\bin\nvim.exe'
Set-Alias v 'C:\scoop\apps\neovim\current\bin\nvim.exe'
Set-Alias g git
Set-Alias e emacs
Set-Alias s 'subl.exe'
Set-Alias obs 'Obsidian.exe'
Set-Alias reboot 'shutdown /r'
Set-Alias xxd 'C:\scoop\apps\git\current\usr\bin\xxd.exe'
Set-Alias touch 'C:\scoop\apps\git\current\usr\bin\touch.exe'
Set-Alias rm 'C:\scoop\apps\git\current\usr\bin\rm.exe'
Set-Alias bash 'C:\scoop\apps\git\current\usr\bin\bash.exe'
Set-Alias grep 'C:\scoop\apps\git\current\usr\bin\grep.exe'
Set-Alias tig 'C:\scoop\apps\git\current\usr\bin\tig.exe'
Set-Alias less 'C:\scoop\apps\git\current\usr\bin\less.exe'
Set-Alias awk 'C:\scoop\apps\git\current\usr\bin\awk.exe'
Set-Alias mv 'C:\scoop\apps\git\current\usr\bin\mv.exe'
Set-Alias perl 'C:\scoop\apps\git\current\usr\bin\perl.exe'
Set-Alias xargs 'C:\scoop\apps\git\current\usr\bin\xargs.exe'

function which ($command) {
  Get-Command $command -ErrorAction SilentlyContinue | Select-Object -ExpandProperty Path -ErrorAction SilentlyContinue
}

function ll {
  eza -lga --icons
}

Set-PSReadLineKeyHandler -Chord "Alt+l" -Function AcceptSuggestion
Set-PSReadLineKeyHandler -Chord "Ctrl+LeftArrow" -Function BackwardWord
# Set-PSReadLineKeyHandler -Chord "Alt+LeftArrow" -Function BackwardWord
Set-PSReadLineKeyHandler -Chord "Ctrl+RightArrow" -Function NextWord
# Set-PSReadLineKeyHandler -Chord "Alt+RightArrow" -Function NextWord
Set-PSReadLineKeyHandler -Chord "Ctrl+Backspace" -Function BackwardKillWord
Set-PSReadLineKeyHandler -Chord "Ctrl+a" -Function SelectAll
Set-PSReadLineKeyHandler -Chord "Ctrl+o" -ScriptBlock { MyFzf } > $null
Set-PSReadLineKeyHandler -Chord "Ctrl+r" -ScriptBlock { MyRg  } > $null

function ide {
  Start-Process wt "sp -H -s 0.30 -d $PWD"
  Start-Sleep -Seconds 0.2
  Start-Process wt "sp -V -s 0.65 -d $PWD"
  Start-Sleep -Seconds 0.2
  Start-Process wt "sp -V -s 0.5 -d $PWD"
  Start-Sleep -Seconds 0.2
}

oh-my-posh init pwsh -c C:\Users\rafae\OneDrive\Documentos\PowerShell\rafaeloledo.omp.json | Invoke-Expression
