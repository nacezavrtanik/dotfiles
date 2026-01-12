#!/bin/bash

colors=(
	"white"
	"black"
	"red"
	"green"
	"blue"
	"cyan"
	"yellow"
	"magenta"
)

declare -A ansi_codes
ansi_codes=(
	["white"]="37"
	["black"]="30"
	["red"]="31"
	["green"]="32"
	["blue"]="34"
	["cyan"]="36"
	["yellow"]="33"
	["magenta"]="35"
)

declare -A rgb_colors
rgb_colors=(
	["white"]="255 255 255"
	["black"]="55 55 55"
	["red"]="255 0 0"
	["green"]="0 255 0"
	["blue"]="0 0 255"
	["cyan"]="0 255 255"
	["yellow"]="255 255 0"
	["magenta"]="255 0 255"
)

declare -A themes
themes=(
	["white"]="Yaru-sage-dark"
	["black"]="Yaru-bark-dark"
	["red"]="Yaru-viridian-dark"
	["green"]="Yaru-viridian-dark"
	["blue"]="Yaru-blue-dark"
	["cyan"]="Yaru-prussiangreen-dark"
	["yellow"]="Yaru-purple-dark"
	["magenta"]="Yaru-magenta-dark"
)

options=(
	-a --all
	-h --help
	-k --keyboard
	-p --prompt
	-t --theme
	-w --wallpaper
)

function usage() {
cat << EOF
Usage: color [OPTION] [COLOR]
Colorize the specified component(s).

COLOR must be one of: white, black, red, green, blue, cyan, yellow, magenta.
If COLOR is not specified, it will be read from the ~/bin/.theme configuration
file. If ~/bin/.theme does not exist, it will be created, with COLOR set to the
default (white).

Options:
  -a, --all          colorize keyboard backlight, terminal prompt, and
                       wallpaper, then save COLOR to the ~/bin/.theme
                       configuration file;
                       this option is used by default if no options
                       are specified;
                       for prompt changes to appear in active terminal,
                       run color with source
  -h, --help         display this help and exit
  -k, --keyboard     colorize the keyboard backlight;
                       will require entering sudo password
  -p, --prompt       colorize the terminal prompt;
                       for changes to appear, color has to be run with
                       source;
                       changes appear in active termnial only
  -t, --theme        colorize theme accent
  -w, --wallpaper    colorize the wallpaper

Exit status:
  0    if everything OK,
  1    otherwise.
EOF
}

function is_in() {
	array_name=$2[@]
	array=("${!array_name}")
	[[ " ${array[*]} " == *" $1 "* ]]
}

function args_from_input() {
	if ! [[ -f ~/dotfiles/color/.theme ]]; then
		default_theme=white
		echo $default_theme > ~/dotfiles/color/.theme
	fi

	case $# in
		0)
			flag=--all
			color=$(< ~/dotfiles/color/.theme)
			;;

		1)
			if is_in $1 colors; then
				flag=--all
				color=$1
			elif is_in $1 options; then
				flag=$1
				color=$(< ~/dotfiles/color/.theme)
			else
				return 1
			fi
			;;

		2)
			if is_in $1 options && is_in $2 colors; then
				flag=$1
				color=$2
			else
				return 1
			fi
			;;

		*)
			return 1
			;;
	esac
	echo $flag $color
}

function colorize_prompt() {
	echo Changing prompt color to $1 ...
	prompt="\[\e[1;${ansi_codes[$1]}m\]<\u\[\e[0m\] \w\[\e[1;${ansi_codes[$1]}m\]>\[\e[0m\] "
	export PS1=$prompt
}

function colorize_keyboard() {
	echo Changing keyboard color to $1 ...
	keyboard_config_file="/sys/class/leds/rgb:kbd_backlight/multi_intensity"
	echo ${rgb_colors[$1]} | sudo tee $keyboard_config_file > /dev/null
}

function colorize_wallpaper() {
	echo Changing wallpaper color to $1 ...
	wallpaper="file:///home/nace/Pictures/Wallpapers/ubuntu-$1.png"
	gsettings set org.gnome.desktop.background picture-uri-dark $wallpaper
}

function colorize_theme() {
	theme="${themes[$1]}"
	echo Changing theme to $theme ...
	gsettings set org.gnome.desktop.interface gtk-theme $theme
}

function colorize() {
	case $1 in
		-h | --help )
			usage
			;;

		-p | --prompt )
			colorize_prompt $2
			;;

		-k | --keyboard )
			colorize_keyboard $2
			;;

		-t | --theme )
			colorize_theme $2
			;;

		-w | --wallpaper )
			colorize_wallpaper $2
			;;

		-a | --all )
			colorize_prompt $2
			colorize_keyboard $2
			colorize_wallpaper $2
			colorize_theme $2
			echo $2 > ~/dotfiles/color/.theme
			;;
	esac
}

if args=$(args_from_input "$@"); then
	colorize $args
else
	usage
	(exit 1)
fi

