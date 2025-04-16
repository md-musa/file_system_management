#!/bin/bash

# Improved File Manager Script with added features

# Colors for better UI
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to display help menu
display_help() {
    echo -e "${YELLOW}File Manager Help Menu${NC}"
    echo -e "${BLUE}1${NC}  - List all files and directories"
    echo -e "${BLUE}2${NC}  - Create new files"
    echo -e "${BLUE}3${NC}  - Delete existing files"
    echo -e "${BLUE}4${NC}  - Rename files"
    echo -e "${BLUE}5${NC}  - Edit file content"
    echo -e "${BLUE}6${NC}  - Search files (enhanced)"
    echo -e "${BLUE}7${NC}  - Show file details"
    echo -e "${BLUE}8${NC}  - View file content"
    echo -e "${BLUE}9${NC}  - Sort file content"
    echo -e "${BLUE}10${NC} - List all directories"
    echo -e "${BLUE}11${NC} - List files by extension"
    echo -e "${BLUE}12${NC} - Count directories"
    echo -e "${BLUE}13${NC} - Count files"
    echo -e "${BLUE}14${NC} - Sort files"
    echo -e "${BLUE}15${NC} - Copy files"
    echo -e "${BLUE}16${NC} - Create directory"
    echo -e "${BLUE}17${NC} - Help (this menu)"
    echo -e "${BLUE}0${NC}  - Exit"
    echo ""
}

# Function to validate filename
validate_filename() {
    local filename=$1
    if [[ "$filename" =~ [^a-zA-Z0-9._-] ]]; then
        echo -e "${RED}Error: Filename contains invalid characters. Only alphanumeric, ., -, and _ are allowed.${NC}"
        return 1
    fi
    return 0
}

# Function to confirm action
confirm_action() {
    local message=$1
    echo -e "${YELLOW}$message (y/n): ${NC}"
    read -r confirm
    [[ "$confirm" =~ ^[Yy]$ ]]
}

# Main loop
while true; do
    clear
    pwd
    echo -e "${GREEN}File Manager${NC}"
    echo "-------------------------------"
    display_help
    
    echo -e "${BLUE}Enter your choice (0-17): ${NC}"
    read -r opt1
    
    # Input validation
    if ! [[ "$opt1" =~ ^[0-9]+$ ]]; then
        echo -e "${RED}Invalid input. Please enter a number.${NC}"
        sleep 2
        continue
    fi
    
    case $opt1 in
        1)  # List all files and directories
            echo -e "${GREEN}List all files and Directories here..${NC}"
            echo -e "${BLUE}Showing all files and directories....${NC}"
            echo "-------------------------------OutPut-------------------------"
            echo "-----------"
            ls -lh --color=auto
            echo " "
            read -rp "Press enter to continue..."
            ;;
            
        2)  # Create New Files
            echo -e "${GREEN}Create New Files here..${NC}"
            echo -e "${YELLOW}Which type of file you want to create!${NC}"
            echo "1- .c"
            echo "2- .sh"
            echo "3- .txt"
            echo "4- Custom extension"
            echo -e "${BLUE}Enter your choice from 1-4: ${NC}"
            read -r filechoice
            
            if ! [[ "$filechoice" =~ ^[1-4]$ ]]; then
                echo -e "${RED}Invalid choice. Please enter 1-4.${NC}"
                sleep 2
                continue
            fi
            
            echo -e "${BLUE}Enter File Name (without extension): ${NC}"
            read -r filename
            
            if ! validate_filename "$filename"; then
                sleep 2
                continue
            fi
            
            case $filechoice in
                1) ext=".c" ;;
                2) ext=".sh" ;;
                3) ext=".txt" ;;
                4) 
                    echo -e "${BLUE}Enter custom extension (without .): ${NC}"
                    read -r customext
                    ext=".$customext"
                    ;;
            esac
            
            if [ -f "${filename}${ext}" ]; then
                echo -e "${YELLOW}File already exists.${NC}"
                if confirm_action "Do you want to overwrite it?"; then
                    touch "${filename}${ext}"
                    echo -e "${GREEN}File overwritten successfully.${NC}"
                else
                    echo -e "${BLUE}File creation cancelled.${NC}"
                fi
            else
                touch "${filename}${ext}"
                echo -e "${GREEN}File created successfully.${NC}"
            fi
            sleep 2
            ;;
            
        3)  # Delete existing files
            echo -e "${GREEN}Delete existing files here..${NC}"
            echo -e "${BLUE}Enter name of File you want to Delete (or 'q' to quit): ${NC}"
            read -r delfile
            
            if [ "$delfile" == "q" ]; then
                continue
            fi
            
            if [ ! -f "$delfile" ]; then
                echo -e "${RED}File '$delfile' does not exist.${NC}"
                sleep 2
                continue
            fi
            
            if confirm_action "Are you sure you want to delete '$delfile'?"; then
                rm "$delfile"
                echo -e "${GREEN}Successfully deleted.${NC}"
            else
                echo -e "${BLUE}Deletion cancelled.${NC}"
            fi
            sleep 2
            ;;
            
        4)  # Rename files
            echo -e "${GREEN}Rename files here..${NC}"
            echo -e "${BLUE}Enter Old Name of File with Extension (or 'q' to quit): ${NC}"
            read -r old
            
            if [ "$old" == "q" ]; then
                continue
            fi
            
            if [ ! -f "$old" ]; then
                echo -e "${RED}File '$old' does not exist.${NC}"
                sleep 2
                continue
            fi
            
            echo -e "${BLUE}Enter New Name for file with Extension: ${NC}"
            read -r new
            
            if ! validate_filename "${new%.*}"; then
                sleep 2
                continue
            fi
            
            if confirm_action "Rename '$old' to '$new'?"; then
                mv "$old" "$new"
                echo -e "${GREEN}Successfully renamed.${NC}"
            else
                echo -e "${BLUE}Rename cancelled.${NC}"
            fi
            sleep 2
            ;;
            
        5)  # Edit file content
            echo -e "${GREEN}Edit file content here..${NC}"
            echo -e "${BLUE}Enter File Name with Extension (or 'q' to quit): ${NC}"
            read -r edit
            
            if [ "$edit" == "q" ]; then
                continue
            fi
            
            if [ ! -f "$edit" ]; then
                echo -e "${RED}File '$edit' does not exist.${NC}"
                if confirm_action "Do you want to create it?"; then
                    touch "$edit"
                    echo -e "${GREEN}File created.${NC}"
                else
                    sleep 2
                    continue
                fi
            fi
            
            echo -e "${YELLOW}Opening file in nano editor...${NC}"
            sleep 1
            nano "$edit"
            ;;
            
        6)  # Enhanced Search files
            echo -e "${GREEN}Enhanced Search files here..${NC}"
            echo "1. Search by name"
            echo "2. Search by content"
            echo "3. Search by extension"
            echo -e "${BLUE}Enter search type (1-3): ${NC}"
            read -r searchtype
            
            case $searchtype in
                1)
                    echo -e "${BLUE}Enter file name to search: ${NC}"
                    read -r searchterm
                    echo -e "${GREEN}Searching for files named '$searchterm'...${NC}"
                    find . -name "*$searchterm*" -print 2>/dev/null | while read -r result; do
                        echo -e "${BLUE}Found: ${YELLOW}$result${NC}"
                    done
                    ;;
                2)
                    echo -e "${BLUE}Enter text to search in files: ${NC}"
                    read -r searchterm
                    echo -e "${GREEN}Searching files containing '$searchterm'...${NC}"
                    grep -rl "$searchterm" . 2>/dev/null | while read -r result; do
                        echo -e "${BLUE}Found in: ${YELLOW}$result${NC}"
                    done
                    ;;
                3)
                    echo -e "${BLUE}Enter file extension to search (without .): ${NC}"
                    read -r searchterm
                    echo -e "${GREEN}Searching for .$searchterm files...${NC}"
                    find . -name "*.$searchterm" -print 2>/dev/null | while read -r result; do
                        echo -e "${BLUE}Found: ${YELLOW}$result${NC}"
                    done
                    ;;
                *)
                    echo -e "${RED}Invalid search type.${NC}"
                    ;;
            esac
            read -rp "Press enter to continue..."
            ;;
            
        15) # Copy files (new feature)
            echo -e "${GREEN}Copy files here..${NC}"
            echo -e "${BLUE}Enter source file path: ${NC}"
            read -r sourcefile
            
            if [ ! -f "$sourcefile" ]; then
                echo -e "${RED}Source file '$sourcefile' does not exist.${NC}"
                sleep 2
                continue
            fi
            
            echo -e "${BLUE}Enter destination path: ${NC}"
            read -r destfile
            
            if [ -f "$destfile" ]; then
                echo -e "${YELLOW}Destination file already exists.${NC}"
                if ! confirm_action "Overwrite?"; then
                    echo -e "${BLUE}Copy cancelled.${NC}"
                    sleep 2
                    continue
                fi
            fi
            
            cp "$sourcefile" "$destfile"
            echo -e "${GREEN}File copied successfully.${NC}"
            sleep 2
            ;;
            
        16) # Create directory (new feature)
            echo -e "${GREEN}Create directory here..${NC}"
            echo -e "${BLUE}Enter directory name: ${NC}"
            read -r dirname
            
            if ! validate_filename "$dirname"; then
                sleep 2
                continue
            fi
            
            if [ -d "$dirname" ]; then
                echo -e "${YELLOW}Directory already exists.${NC}"
                sleep 2
                continue
            fi
            
            mkdir "$dirname"
            echo -e "${GREEN}Directory created successfully.${NC}"
            sleep 2
            ;;
            
        17) # Help menu
            display_help
            read -rp "Press enter to continue..."
            ;;
        18) # Help menu
            display_help
            cd ..
            pwd
            read -rp "Press enter to continue..."
            ;;
            
        0)  # Exit
            echo -e "${GREEN}Good Bye..${NC}"
            echo -e "${GREEN}Successfully Exit${NC}"
            exit 0
            ;;
            
        *)  # Invalid option
            echo -e "${RED}Invalid Input.. Please try again....${NC}"
            sleep 2
            ;;
    esac
done