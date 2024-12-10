#!/bin/bash

# 2024-08-06

# Group 4 Final Project
# Mehakpreet Kaur
# Mir Ahmad Ali
# Mohammed Rijhve Ahammed Rasa
# Muaaz Wahid

# Bash script that draws shapes with different colors, effects, and animation
# This is a bash script that repeatedly prompts a user for input

# Source the shapes file
# this allows us to access all the string shape variables inside this script
source ./shapes_list.sh

#################### BEGINNING OF FUNCTIONS ####################

# Helper function to print the shape with given indent
print_shape_with_indent() {
    # shape (passed in as a string) to print
    local shape="$1"
    # spaces to indent with
    local indent=$2
    # clears the screen
    clear
    # print formatted output of while loop
    # use reset ANSI code to reset formatting
    # while loop to process each line of the shape
    # IFS is internal field seperator
    echo -e "${format_text}${shape}${reset_text}" | while IFS= read -r line; do
        # ignore newline characters and add indentation
        printf "%*s%s\n" $indent "" "$line"
    done
}

# Function to create the waving effect
waving_animation() {
    # shape (passed in as a string) to print
    # $1 is a variable passed into this function
    local shape="$1"
    for i in {1..2}; do
        # the for loops below run 5 times so the effect is short but visible
        # the sleep command adds a delay for an animated effect

        # Move shape right
        for ((indent = 0; indent <= 5; indent++)); do
            print_shape_with_indent "$shape" $indent
            sleep 0.2
        done
        # Move shape left
        for ((indent = 5; indent >= 0; indent--)); do
            print_shape_with_indent "$shape" $indent
            sleep 0.2
        done
    done
}

# Randomize the shape characters
scramble_animation() {
    # shape (passed in as a string) to print
    local shape="$1"
    # Characters to use for scramble
    local scramble_chars="* # @ $ % &"
    
    # Convert shape into an array of lines
    # set Internal Field Separator (IFS) to newline character
    # -d '' just tells to read till EOF
    # -r preserves '\' character in shape
    # -a store input in an array
    # <<< means provide input (right to left) to a command as a string
    IFS=$'\n' read -d '' -r -a shape_lines <<< "$shape"
    
    for i in {1..20}; do
        # clear the screen
        clear
        for line in "${shape_lines[@]}"; do
            # using awk to substitute random characters
            # -v option holds the chars as a variable inside awk script
            scrambled_shape=$(echo "$line" | awk -v chars="$scramble_chars" '
                BEGIN {
                    # hold random chars in an array
                    split(chars, arr, " ");
                    # Seed the random number generator
                    srand();
                }
                {
                    result = "";
                    # iterate over each character on the current line
                    for (i = 1; i <= length($0); i++) {
                        # store current char using substr
                        char = substr($0, i, 1);
                        # if the character is "*", scramble it
                        if (char == "*") {
                            # choose a random char to substitute
                            result = result arr[int(rand() * length(arr)) + 1];
                        } else {
                            result = result char;
                        }
                    }
                    print result;
                }
            ')
            # print shape with user formatting
            echo -e "${format_text}${scrambled_shape}${reset_text}"
            # delay for animation effect
            sleep 0.2
        done
    done
    # clear screen to print final shape
    clear
    echo -e "${format_text}${shape}${reset_text}"
}

# Color Cycling
color_cycling_animation() {
    local shape="$1"  
    # ANSI CODES
    # text colors: red, green, yellow, blue, purple, cyan, white
    local colors=("\033[31m" "\033[32m" "\033[33m" "\033[34m" "\033[35m" "\033[36m")
    # background colors: red, green, yellow, blue, purple, cyan, white
    local bg_colors=("\033[41m" "\033[42m" "\033[43m" "\033[44m" "\033[45m" "\033[46m")
    for ((i = 0; i < 20; i++)); do
        # from both colors and background colors array
        # choose a random index to select a random color element
        # use (()) double parenthesis for calculations
        local rand_color=${colors[$(($RANDOM % ${#colors[@]}))]}
        local rand_bg_color=${bg_colors[$(($RANDOM % ${#bg_colors[@]}))]} 
        # clear is needed to reset screen to give the 'cycling' effect
        clear
        printf "${rand_bg_color}${rand_color}${shape}${reset_text}\n"
        sleep 0.2
    done
    # after cycling colors, print shape as user specified
    clear
    printf "${format_text}${shape}${reset_text}\n"
}

# Pulsing Effect
pulsing_animation() {
    local shape="$1"
    # clear screen for pulse effect
    clear
    for i in {1..7}; do
        # Print shape with user selected formatting
        printf "${format_text}${shape}${reset_text}\n"
        sleep 0.2
        clear
        # Print shape with default formatting
        printf "${shape}\n"
        sleep 0.2
        clear
    done
    # Print shape with user selected formatting
    printf "${format_text}${shape}${reset_text}\n"
}

# Bouncing Effect
bouncing_animation() {
    local shape="$1"
    # for each 'bounce' clear the screen and print the text below
    for i in {1..10}; do
        # Clear the screen prior to animation
        clear
        printf "\n\n${format_text}${shape}${reset_text}\n"
        sleep 0.2
        clear
        printf "\n\n\n\n\n${format_text}${shape}${reset_text}\n"
        sleep 0.2
    done
}

# Prompt and process user input on how to output shape
prompt_and_process_user_choices() {
    #################### Begin prompting shape output ####################

    # Prompt user shape choice
    printf "\nChoose a shape:\n"
    printf "1: rectangle, 2: square, 3: triangle, 4: circle\n"
    printf "5: x, 6: arrow, 7: heart, 8: diamond, 9: starburst\n"
    printf "10: cube, 11: full rectangle, 12: full square\n"
    printf "13: full triangle, 14: full circle, 15: full x\n"
    printf "16: full arrow, 17: full heart, other: default\n"
    # Read user input for shape choice
    read user_shape_choice

    # Prompt user text color choice
    printf "\nChoose a shape color:\n"
    printf "1: red, 2: green, 3: yellow, 4: blue\n"
    printf "5: purple, 6: cyan, 7: white, other: default\n"
    # Read user input for text color
    read user_text_color

    # Prompt user background color choice
    printf "\nChoose a background color:\n"
    printf "1: red, 2: green, 3: yellow, 4: blue\n"
    printf "5: purple, 6: cyan, 7: white, other: default\n"
    # Read user input for background color
    read user_bg_color
    
    # Prompt user animation choice
    printf "\nChoose an animation:\n"
    printf "1: Pulsing, 2: Bouncing, 3: Scramble, 4: Waving\n"
    printf "5: Color Cycling, other: none\n"
    # Read user input for animation choice
    read animation_choice
    
    # if user did not choose animation, prompt them on text effects
    if [[ ! "$animation_choice" =~ ^[1-5]$ ]]; then
        # Get user text modification choice
        printf "\nChoose a text effect:\n"
        printf "1: italics, 2: underline, 3: blink, other: default\n"
        # Read user input for text effect
        read user_modification
    fi
    #################### End of prompting shape output ####################
    
    # If user input is not a valid digit, then assign default values
    # assign shape to shape variable
    # These shapes are all referenced in shapes_list.sh
    case "$user_shape_choice" in
        "1")  user_shape_choice="$SHAPE_RECTANGLE" ;;
        "2")  user_shape_choice="$SHAPE_SQUARE" ;;
        "3")  user_shape_choice="$SHAPE_TRIANGLE" ;;
        "4")  user_shape_choice="$SHAPE_CIRCLE" ;;
        "5")  user_shape_choice="$SHAPE_X" ;;
        "6")  user_shape_choice="$SHAPE_ARROW" ;;
        "7")  user_shape_choice="$SHAPE_HEART" ;;
        "8")  user_shape_choice="$SHAPE_DIAMOND" ;;
        "9")  user_shape_choice="$SHAPE_STAR_BURST" ;;
        "10") user_shape_choice="$SHAPE_CUBE" ;;
        "11") user_shape_choice="$SHAPE_RECTANGLE_FULL" ;;
        "12") user_shape_choice="$SHAPE_SQUARE_FULL" ;;
        "13") user_shape_choice="$SHAPE_TRIANGLE_FULL" ;;
        "14") user_shape_choice="$SHAPE_CIRCLE_FULL" ;;
        "15") user_shape_choice="$SHAPE_X_FULL" ;;
        "16") user_shape_choice="$SHAPE_ARROW_FULL" ;;
        "17") user_shape_choice="$SHAPE_HEART_FULL" ;;
        "0"|"*") user_shape_choice="$SHAPE_RECTANGLE" ;; # default shape
    esac

    # re-assign variables to hold
    # ANSI values for text modification
    # map user choice to ANSI value for text coloring
    case "$user_text_color" in
        1) user_text_color="\033[0;31m" ;; # red
        2) user_text_color="\033[0;32m" ;; # green
        3) user_text_color="\033[0;33m" ;; # yellow
        4) user_text_color="\033[0;34m" ;; # blue
        5) user_text_color="\033[0;35m" ;; # purple
        6) user_text_color="\033[0;36m" ;; # cyan
        7) user_text_color="\033[0;37m" ;; # white
        *) user_text_color="\033[0m" ;; # default
    esac

    # map user choice to ANSI value for background text coloring
    case "$user_bg_color" in
        1) user_bg_color="\033[41m" ;; # background red
        2) user_bg_color="\033[42m" ;; # background green
        3) user_bg_color="\033[43m" ;; # background yellow
        4) user_bg_color="\033[44m" ;; # background blue
        5) user_bg_color="\033[45m" ;; # background purple
        6) user_bg_color="\033[46m" ;; # background cyan
        7) user_bg_color="\033[47m" ;; # background white
        *) user_bg_color="\033[49m" ;; # default (no background)
    esac

    # map user choice to ANSI value for text effects
    case "$user_modification" in
        1) user_modification="\033[3m" ;; # italicized text
        2) user_modification="\033[4m" ;; # underlined text
        3) user_modification="\033[5m" ;; # blinking text
        *) user_modification="\033[1m" ;; # default text
    esac
}
#################### END OF FUNCTIONS ####################

############# Prompt before main loop ###############
# Add a beep sound with delay for fun and effects
# \a is the ASCII bell character
sleep 0.5; printf "*beep*\n\a"; sleep 0.5;
# Prompt and get user name
# use $USER environment variable to initially address user
echo "Hello $USER. Which user is running this program?"
# Read user input for name
read user_name

#################### MAIN LOOP ####################
# infinite while loop to continually prompt user for new shape
while true; do
    # Prompt user for shape and how to output shape
    prompt_and_process_user_choices
    # Define the formatting string & reset text according to user preferences
    # $user_text_color, $user_bg_color, $user_modification
    # are all variables set by the user input in the previous function
    format_text="${user_text_color}${user_bg_color}${user_modification}"
    # Reset formatting
    # reset ANSI code for text, will start printing text normally
    # ANSI allows us to add effects to terminal text
    # (color, background color, italics, etc.)
    reset_text="\033[0m"
 
    ######## Print the user selected output ########
    # print shape with chosen animation or basic text effects
    # call on the matching function based on user input
    case "$animation_choice" in
        "1") pulsing_animation "$user_shape_choice" ;;
        "2") bouncing_animation "$user_shape_choice" ;;
        "3") scramble_animation "$user_shape_choice" ;;
        "4") waving_animation "$user_shape_choice" ;;
        "5") color_cycling_animation "$user_shape_choice" ;;
        # No animation, just print shape
        *) printf "${format_text}${user_shape_choice}${reset_text}\n" ;;
    esac

    # Address the user
    printf "\n\nYour shape has been printed in the color you chose "
    # print $user_name with user chosen formatting
    printf "${format_text}${user_name}${reset_text}\n"
    
    # Prompt if user wants to save output to file
    # this if statement checks if user declined to animate
    if [[ ! "$animation_choice" =~ ^[1-5]$ ]]; then
        echo "Would you like to save your output to a file (y/n)?"
        # Read user input for saving output
        read save_output
    fi
    # if user chose yes, save output to file
    # we do this by overwriting file with new shape output
    if [ "$save_output" == "y" ]; then
        # print shape with user chosen formatting
        printf "${format_text}${user_shape_choice}${reset_text}\n" > output_file.txt
        # print text normally
        printf "${reset_text}\ncreated by " >> output_file.txt
        # print $user_name with user chosen formatting
        printf "${format_text}${user_name}${reset_text}\n" >> output_file.txt
        # tell user name of file and where it is
        # escape double quotes to print double quotes in terminal
        printf "\nCreated file \"output_file.txt\" stored at\n"
        # using realpath command we can print
        # the absolute path of the output file
        printf "$(realpath output_file.txt)\n"
        printf "\nContents of output_file.txt:\n"
        # cat outputs contents of a file
        cat output_file.txt
        # Reset save_output variable
        save_output="n"
    fi

    # Prompt if the user wants to run the script again
    printf "\nDo you want to draw another shape? (y/n)\n"
    read user_choice
    # if user does not answer yes, exit main loop
    if [ "$user_choice" != "y" ]; then break; fi
done
#################### END OF MAIN LOOP ####################

# Thank the user for playing
# print a goodbye message in using ANSI codes
# italicized black text on a blue background
printf "\033[44m\033[30m\033[3m"
printf "Thank You And Goodbye!\033[0m\n"

# wait for a second
sleep 1
# use explorer.exe (windows-specific command)
# to open a png file and to run mp3 file
explorer.exe "yay.mp3"
explorer.exe "thanks.png"
# exit script
exit 0

