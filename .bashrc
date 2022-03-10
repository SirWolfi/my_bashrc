
#
# userdefined
#

MUSIC_DIR="/home/sirwolf/Musik" # change these to what you like
GAME_DIR="/home/sirwolf/Games" 
DESKTOP_DIR="/home/sirwolf/Schreibtisch"

get-extention() {
	local NAME
	local EXT
	NAME=$(basename -- "$1")
	EXT="${NAME##*.}"

	echo $EXT
}

get-basename() {
	local NAME
	NAME=$(basename -- "$1")

	echo $NAME
}

# compiles a full directory
# # usage: compileCpp <dir>
compileCpp() {
	local dir
	local extra
	local files
	dir=$1
	extra=$2

	if [[ $2 == "" ]]; then
		extra = "-std=c++17 -g -o main"
	fi
	files=""
	for i in $dir/*; do
		if [[ $( get-extention $i ) == "cpp" ]]; then
			files=$files$i" "
		fi
		
	done

	g++ $files $extra
}

hello_message() {
	local S
	local pre
	local post
	post="\e[m\n\n"
	pre="\n\e[1m"
	S=$(expr $RANDOM % 11)
	case "$S" in
		0) printf $pre"Goood Moring! ^.^!"$post ;;
		1) printf $pre"Hello Master! ^^/"$post ;;
		2) printf $pre"Having a productive day? ^^"$post ;;
		3) printf $pre"Wish you the best!!"$post ;;
		4) printf $pre"Go get 'em, keyboard cat! ^°^"$post ;;
		5) printf $pre"Have been gone for a while huh? ;p"$post ;;
		6) printf $pre"Please be kind ;-;"$post ;;
		7) printf $pre"Hiii !!"$post ;;
		8) printf $pre"You have it ^*^//"$pre ;;
		9) printf $pre"Heyy! Master is back!!! \(^-^)/"$post ;;
		10) printf $pre"Master! You are back!! \(8-8)\\ "$post ;;
	esac
}

compile() {
	case "$1" in
		*.sh) ./"$1" ;;
		*.bash) ./"$1" ;;
		*.py) python $1 ;;
		*.cpp) g++ $1 ;;
		*.c) gcc $1 ;;
		*.jar) java -jar $1 ;;
		default) printf "Unknwon file!" ;;
	esac
}

compileSDL() {
	sdl2-config --clfag --libs
}

include() {
	eval $(cat "$@")
}


extra-bashrc-helper() {
	if [[ -d ~/.extra_bashrc ]]; then
		printf ""
	else
		mkdir ~/.extra_bashrc
	fi
	local C
	C=$(pwd)
	
	cd ~/.extra_bashrc
	
	if [[ -f "main.bash" ]]; then
		eval $(cat "main.bash")
	fi

	cd "$C"
}

# Setup

extra-bashrc-helper
hello_message

# aliase

alias todo="$DESKTOP_DIR/Programming/Nodes/start.sh"
alias rl-sudo="/usr/bin/sudo"
alias sudo="echo sudowo && rl-sudo" #bc weeb
alias sudowo="sudo"
alias new_link="exo-desktop-item-edit --create-new Link"

alias gimme-music="vlc $MUSIC_DIR"
alias mall="gimme-music"

alias "im-feeling-lucky"="good_day"
alias "typo-fail-message"="echo ;-; Typos are a crime, didn't you know?"

good_day() {
	( trap 'kill 0' SIGINT; code $DESKTOP_DIR/Programming/ & gimme-music & steam &  discord & firefox )
}

gaming() {
	( trap 'kill 0' SIGINT; steam &  discord & lutris )
}

coding() {
	echo What music can i give you?
	read MUSIC
	
	if [[ $MUSIC == "" ]]; then
		( trap 'kill 0' SIGINT; code $DESKTOP_DIR/Programming/ & gimme-music & firefox )
	elif [[ $MUSIC != "none" ]]; then
		( trap 'kill 0' SIGINT; code $DESKTOP_DIR/Programming/ & music_lib open $MUSIC & firefox )
	fi
}

new_game() {
	new_link --name "$1" --icon preferences-desktop-gaming --url "$(pwd)" --command ".$(pwd)/$2"
}

open_bashrc() {
	mousepad ~/.bashrc
}


# My little game manager when i'm too lazy to use lutris
#
# Usage: game_lib [OPTIONS]
#
# Options:
# - play <game> : plays the game
# - list 			: list all installed games 
# - find <name> : searches for NAME
# - help 		: prints this
game_lib() {
	CURRENT=$(pwd)
	#if [[ $2 == "" && "$1" != "list" || "$1" != "--help" ) ]]; then
	#	printf "\n\e[1mNo name of file given!\e[m\n"
	#else
	case "$1" in
		play)
		cd $GAME_DIR
		for i in *; do
			if [[ -d "$i" ]]; then
			cd ./"$i"
			for j in *; do
			if [[ "$j" == *"$2"* && $(get-extention $j) == "x86" ]]; then
				chmod +x "$j"
				./"$j"
				cd $CURRENT
				printf "Found \"$j\"!\n"
				return 0
			fi
			if [[ "$j" == *"$2"*  && $(get-extention $j) == "x86_64" ]]; then
				chmod +x "$j"
				./"$j"
				cd $CURRENT
				printf "Found \"$j\"!\n"
				return
			fi
			if [[ "$j" == *"$2"*  && $(get-extention $j) == "exe" ]]; then
				chmod +x "$j"
				wine "$j"
				cd $CURRENT
				printf "Found \"$j\"!\n"
				return 0
			fi
			if [[ "$j" == *"$2"*  && $(get-extention $j) == "sh" ]]; then
				chmod +x "$j"
				./"$j"
				cd $CURRENT
				printf "Found \"$j\"!\n"
				return 0
			fi
			done
			cd ..
			fi
		done
		printf "Found no game called $2 in $GAME_DIR ! \n"
		;;
		list) 
		printf "List of all games installed:\n"
		cd $GAME_DIR
		for i in *; do
			if [[ -d "$i" ]]; then
			cd ./"$i"
			for j in *; do
			if [[ $(get-extention $j) == "x86" ]]; then
				printf "\"$j\"-----------------------------(Linux native)\n"
			fi
			if [[ $(get-extention $j) == "x86_64" ]]; then
				printf "\"$j\"-----------------------------(Linux native)\n"
			fi
			if [[ $(get-extention $j) == "exe" ]]; then
				printf "\"$j\"-----------------------------(Wine)\n"
			fi
			if [[ $(get-extention $j) == "sh" ]]; then
				printf "\"$j\"-----------------------------(Bash)\n"
			fi
			done
			cd ..
			fi
		done
		;;
		delete) ;; # No
		find) 
			printf "List of all games installed:\n"
			cd $GAME_DIR
			for i in *; do
				if [[ -d "$i" ]]; then
					cd ./"$i"
					for j in *; do
						if [[ "$j" == *"$2"* && $(get-extention $j) == "x86" ]]; then
							printf "\"$j\"-----------------------------(Linux native)\n"
						fi
						if [[ "$j" == *"$2"*  && $(get-extention $j) == "x86_64" ]]; then
							printf "\"$j\"-----------------------------(Linux native)\n"
						fi
						if [[ "$j" == *"$2"*  && $(get-extention $j) == "exe" ]]; then
							printf "\"$j\"-----------------------------(Wine)\n"
						fi
						if [[ "$j" == *"$2"*  && $(get-extention $j) == "sh" ]]; then
							printf "\"$j\"-----------------------------(Bash)\n"
						fi
						done
						cd ..
				fi
			done
			;;
		help) 
			echo "My little game manager when i'm too lazy to use lutris"
			echo
			echo Usage: game_lib [OPTIONS]
			echo
			echo Options:
			echo -e " - play <game>\t\t: plays the game"
			echo -e " - list\t\t\t: list all installed games "
			echo -e " - find <name>\t\t: searches for NAME"
			echo -e " - help\t\t\t: prints this"
		
	esac
	#fi
}

# My little music manager
#
# Usage: music_lib [OPTIONS]
#
# Options:
# - open <song>\t\t: plays the song"
# - playlist <song1> ... <songn>]\t: plays the songs from song 1 to n
# - playlist-L <song1> ... <songn>\t: loops the playlist
# - find <name>\t\t: searches for NAME
# - help\t\t\t: prints this
music_lib() {
	CURRENT=$(pwd)
	case "$1" in
		open)
		cd $MUSIC_DIR
		for i in *; do
			if [[ -d "$i" ]]; then
			cd ./"$i"
			for j in *; do
			if [[ "$j" == *"$2"* && $(get-extention "$j") == "mp4" ]]; then
				cvlc --play-and-exit --no-loop "$j"
				cd $CURRENT
				printf "Found \"$j\"!\n"
				return 0
			fi
			if [[ "$j" == *"$2"*  && $(get-extention "$j") == "wav" ]]; then
				cvlc --play-and-exit --no-loop "$j"
				cd $CURRENT
				printf "Found \"$j\"!\n"
				return
			fi
			if [[ "$j" == *"$2"*  && $(get-extention "$j") == "mp3" ]]; then
				cvlc --play-and-exit --no-loop "$j"
				cd $CURRENT
				printf "Found \"$j\"!\n"
				return 0
			fi
			if [[ "$j" == *"$2"*  && $(get-extention "$j") == "ogg" ]]; then
				cvlc --play-and-exit --no-loop "$j"
				cd $CURRENT
				printf "Found \"$j\"!\n"
				return 0
			fi
			done
			cd ..
			else
			if [[ "$i" == *"$2"* && $(get-extention $i) == "mp4" ]]; then
				cvlc --play-and-exit --no-loop "$i"
				printf "Found \"$i\"!\n"
				return 0
			fi
			if [[ "$i" == *"$2"*  && $(get-extention $i) == "wav" ]]; then
				cvlc --play-and-exit --no-loop "$i"
				cd $CURRENT
				printf "Found \"$i\"!\n"
				return 0
			fi
			if [[ "$i" == *"$2"*  && $(get-extention $i) == "mp3" ]]; then
				cvlc --play-and-exit --no-loop "$i"
				cd $CURRENT
				printf "Found \"$i\"!\n"
				return 0
			fi
			if [[ "$i" == *"$2"*  && $(get-extention $i) == "ogg" ]]; then
				cvlc --play-and-exit --no-loop "$i"
				cd $CURRENT
				printf "Found \"$i\"!\n"
				return 0
			fi
			fi
		done
		printf "Found no music called $2 in $MUSIC_DIR ! \n"
		cd $CURRENT
		;;
		find) 
			printf "List of all music files installed:\n"
		cd $MUSIC_DIR
		for i in *; do
			if [[ -d "$i" ]]; then
			printf "\"$i\" (dir)\n"
			cd ./"$i"
			for j in *; do
			if [[ "$j" == *"$2"* && $(get-extention "$j") == "mp4" ]]; then
				printf "\"$j\"\n"
			fi
			if [[ "$j" == *"$2"*  && $(get-extention "$j") == "wav" ]]; then
				printf "\"$j\"\n"
			fi
			if [[ "$j" == *"$2"*  && $(get-extention "$j") == "mp3" ]]; then
				printf "\"$j\"\n"
			fi
			if [[ "$j" == *"$2"*  && $(get-extention "$j") == "ogg" ]]; then
				printf "\"$j\"\n"
			fi
			done
			cd ..
			else
			if [[ "$i" == *"$2"* && $(get-extention $i) == "mp4" ]]; then
				printf "\"$i\"\n"
			fi
			if [[ "$i" == *"$2"*  && $(get-extention $i) == "wav" ]]; then
				printf "\"$i\"\n"
			fi
			if [[ "$i" == *"$2"*  && $(get-extention $i) == "mp3" ]]; then
				printf "\"$i\"\n"
			fi
			if [[ "$i" == *"$2"*  && $(get-extention $i) == "ogg" ]]; then
				printf "\"$i\"\n"
			fi
			fi
		done
		cd $CURRENT
		;;
		help) 			
			echo "My little music manager"
			echo
			echo Usage: music_lib [OPTIONS]
			echo
			echo Options:
			echo -e " - open <song>\t\t: plays the song"
			echo -e " - playlist <song1> ... <songn>]\t: plays the songs from song 1 to n"
			echo -e " - playlist-L <song1> ... <songn>\t: loops the playlist"
			echo -e " - find <name>\t\t: searches for NAME"
			echo -e " - help\t\t\t: prints this"
		 ;;
		playlist) 
		if [[ $# == 2 ]]; then
			cd $MUSIC_DIR
			
			if [[ -d "$MUSIC_DIR/$2" ]]; then
				cvlc $MUSIC_DIR/$2
			else
				echo "No playlist named $2 in $MUSIC_DIR !"
			fi
			cd $LAST	
		else
			for i in "$@"; do
				if [[ "$i" == "playlist" ]]; then
					continue
				fi
				if [[ "$i" == "playlist-L" ]]; then
					continue
				fi			

				echo playing \"$i\"
				music_lib open "$i"
			done
		fi
		;;
		playlist-L) 
			while true; do
				music_lib playlist "$@"
			done
		;;
		
	esac
	#fi
}

make_project() {
	mkdir src
	mkdir bin
	mkdir inc
}

tool-list() {
	for i in "make_project" "music_lib" "game_lib" "open_bashrc" "compile" "hello_message"; do
		echo $i
	done
}

tools() {
	case "$1" in
	help)	printf "Tool-list of SirWolfs bash tools\n\nUsage: tools [help|info|list] [tool]\n" 
	;;
	list) echo List of all Tools: 
		tool-list
	;;
	info)
		if [[ $2 == "" ]]; then
			echo Invalid argument!
		else
			"$2" help
		fi
	;;
		

	esac	
}

menu() {
	clear
	while true; do
		printf "\t############## MENU ###############\n"
		echo ""
		printf "\t\tWhat do you need?\n"
		printf "\t\t   : "
		read DO WITH
		clear
		if [[ $DO == "play" ]]; then
			game_lib play $WITH
		elif [[ $DO == "open" ]]; then
			music_lib open $WITH
		elif [[ $DO == "playlist" ]]; then
			music_lib playlist $WITH
		elif [[ $DO == "info" ]]; then
			tools $WITH
		elif [[ $DO == "project" ]]; then
			local C
			C=$(pwd)
			cd "$WITH"
			make_project
			cd "$C"
		elif [[ $DO == "loop" ]]; then
			music_lib playlist-L $WITH
		elif [[ $DO == "find" ]]; then
			printf "music or game: "
			read CH
			if [[ $CH == "music" ]]; then
				music_lib find $WITH
			elif [[ $CH == "game" ]]; then
				game_lib find $WITH
			fi
		elif [[ $DO == "exit" || $DO == "" ]]; then
			break
		else 
			echo Unknown command: \"$DO\"
			sleep 2
		fi
		printf "\n\n--------------------|\n"
		echo Next?
		printf "[Y/n]"
		read INP
		if [[ $INP == "n" || $INP == "N" || $INP == "no" ]]; then
			break
		fi
		clear
	done
	clear
}



