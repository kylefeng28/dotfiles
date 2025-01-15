# ~/.config/fish/functions/fish_prompt.fish

# Based on clearance, which is based on idan.

# Git prompt
# https://github.com/meyer/fish-prompt/blob/master/fish_prompt.fish
# https://www.martinklepsch.org/posts/git-prompt-for-fish-shell.html
set __fish_git_prompt_showcolorhints 'yes'
set __fish_git_prompt_showdirtystate 'yes'
set __fish_git_prompt_showupstream 'auto'
set __fish_git_prompt_show_informative_status 'yes'
set __fish_git_prompt_char_stateseparator ' '
set __fish_git_prompt_showstashstate 'yes'
set __fish_git_prompt_showuntrackedfiles 'yes'
set __fish_git_prompt_color_branch yellow
set __fish_git_prompt_color_upstream_ahead green
set __fish_git_prompt_color_upstream_behind red

# Status Chars
set __fish_git_prompt_char_dirtystate '!'
set __fish_git_prompt_char_stagedstate '→'
set __fish_git_prompt_char_untrackedfiles '☡'
set __fish_git_prompt_char_stashstate '↩'
set __fish_git_prompt_char_upstream_ahead '+'
set __fish_git_prompt_char_upstream_behind '-'

function _remote_hostname
	echo (whoami)@(hostname -s)
end

function fish_prompt
	set -l last_status $status

	# Colors
	set -l cyan (set_color cyan)
	set -l yellow (set_color yellow)
	set -l red (set_color red)
	set -l blue (set_color blue)
	set -l green (set_color green)
	set -l normal (set_color normal)
	set -l mywhite (set_color -o white)
	set -l mygreen (set_color -o green)

	# set -l cwd $blue(pwd | sed "s:^$HOME:~:")
	# set -l dove $mygreen (pwd | sed "s:^$HOME:~:")

	set -l suffix '⟩ '
	set -l dove $mygreen (prompt_pwd) $normal
	set -l ps1 '(' $cyan (date "+%a %Y-%m-%d%n %H:%M:%S") $normal ') <' $last_status '> '

	# Output the prompt, left to right

	# Add a newline before new prompts
	echo -e ''

	# Print time and exit code
	echo -n -s $ps1 $normal

	# Print pwd or full path
	echo -n -s '[' $dove ']'

	# Show git branch and status
	echo -n (__fish_git_prompt)

	# Newline
	echo -e ''

	# Show SSH status
	if [ -n "$SSH_CLIENT" ]
		echo -n -s $green '(ssh) ' $normal
	end

	# Show kerberos status
	# if not klist -s 2> /dev/null
	#	echo -n -s $red '(!k) ' $normal
	# end

	# Terminate with a nice prompt char
	echo -e -n -s (_remote_hostname) $suffix $normal
end

# Default fish prompt
# function fish_prompt_default --description "Write out the prompt"
# 	set -l color_cwd
# 	set -l suffix
# 	switch "$USER"
# 		case root toor
# 			if set -q fish_color_cwd_root
# 				set color_cwd $fish_color_cwd_root
# 			else
# 				set color_cwd $fish_color_cwd
# 			end
# 			set suffix '#'
# 		case '*'
# 			set color_cwd $fish_color_cwd
# 			set suffix '>'
# 	end
#
# 	echo -n -s "$USER" @ (prompt_hostname) ' ' (set_color $color_cwd) (prompt_pwd) (set_color normal) "$suffix "
# end
