# Windows PowerShell profile
# %USERPROFILE\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1
# This can also be accessed using the handy variable $profile

# https://github.com/felixrieseberg/windows-development-environment/blob/master/Microsoft.PowerShell-profile.ps1

# Increase history
$MaximumHistoryCount = 10000

# Produce UTF-8 by default
$PSDefaultParameterValues["Out-File:Encoding"]="utf8"

# Set emacs-style bindings (C-a, C-e, C-p, C-n, etc)
Set-PSReadLineOption -EditMode Emacs

# Show selection menu for tab
Set-PSReadlineKeyHandler -Chord Tab -Function MenuComplete

# Import the Chocolatey Profile that contains the necessary code to enable
# tab-completions to function for `choco`.
# Be aware that if you are missing these lines from your profile, tab completion
# for `choco` will not function.
# See https://ch0.co/tab-completion for details.
# 
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
  Import-Module "$ChocolateyProfile"
}

# Helper Functions
#######################################################

function make-link ($link, $target) {
	# Notice the order of $link and $target: this mirrors the cmd version: mklink $link $target
	# but is the opposite of the Unix version: ln -s $target $link
	New-Item -Path $link -ItemType SymbolicLink -Value $target
}


function uptime {
	Get-WmiObject win32_operatingsystem | select csname, @{LABEL='LastBootUpTime';
	EXPRESSION={$_.ConverttoDateTime($_.lastbootuptime)}}
}

function reload-profile {
	& $profile
}

function find-file($name) {
	ls -recurse -filter "*${name}*" -ErrorAction SilentlyContinue | foreach {
		$place_path = $_.directory
		echo "${place_path}\${_}"
	}
}

function print-path {
	($Env:Path).Split(";")
}

function unzip ($file) {
	$dirname = (Get-Item $file).Basename
	echo("Extracting", $file, "to", $dirname)
	New-Item -Force -ItemType directory -Path $dirname
	expand-archive $file -OutputPath $dirname -ShowProgress
}


# Unix-like commands
#######################################################

function df {
	Get-Volume
}

function which($name) {
	Get-Command $name | Select-Object -ExpandProperty Definition
}

function export($name, $value) {
	set-item -force -path "env:$name" -value $value;
}

function pkill($name) {
	ps $name -ErrorAction SilentlyContinue | kill
}

function pgrep($name) {
	ps $name
}

function touch($file) {
	"" | Out-File $file -Encoding ASCII
}

