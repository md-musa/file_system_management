#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' 


validate_filename() {
    local filename=$1
    if [[ "$filename" =~ [^a-zA-Z0-9._-] ]]; then
        echo -e "${RED}Filename contains invalid characters. Only alphanumeric ., -, and _ are allowed.${NC}"
        return 1
    fi
    return 0
}

confirm_action() {
    local message=$1
    echo -e "${YELLOW}${message} (y/n): ${NC}"
    read -r confirm

    if [[ "$confirm" =~ ^[Yy]$ ]]; then
        return 0 
    else
        return 1 
    fi
}

show_location() {
    clear
    echo -e "${CYAN}Current directory: ${YELLOW}$(pwd)${NC}"
    echo -e "${BLUE}Available folders:${NC}"
    ls -d */
    echo "----------------------------------------"
}

display_help() {
    echo -e "${YELLOW}File Manager Help Menu${NC}"
    echo -e "${BLUE}1${NC}  - List all files and directories"
    echo -e "${BLUE}2${NC}  - Create new files"
    echo -e "${BLUE}3${NC}  - Delete existing files"
    echo -e "${BLUE}4${NC}  - Rename files"
    echo -e "${BLUE}5${NC}  - Edit file content"
    echo -e "${BLUE}6${NC}  - Search files"
    echo -e "${BLUE}7${NC}  - View file content"
    echo -e "${BLUE}8${NC} - List all directories"
    echo -e "${BLUE}9${NC} - List files by extension"
    echo -e "${BLUE}10${NC} - Count directories"
    echo -e "${BLUE}11${NC} - Count files"
    echo -e "${BLUE}12${NC} - Sort files"
    echo -e "${BLUE}13${NC} - Create directory"
    echo -e "${BLUE}14${NC} - Go to parent directory"
    echo -e "${BLUE}15${NC} - Go to subdirectory"
    echo -e "${BLUE}0${NC}  - Exit"
    echo ""
}


while true; do
    show_location
    display_help
    
    echo -e "${BLUE}Enter your choice (0-19): ${NC}"
    read -r opt1
    
    # Input validation
    if ! [[ "$opt1" =~ ^[0-9]+$ ]]; then
        echo -e "${RED}Invalid input. Please enter a number.${NC}"
        sleep 1
        continue
    fi
    
    case $opt1 in
        1)  # View files
            echo -e "${GREEN}List all files and Directories here..${NC}"
            echo "-------------------------------OutPut-------------------------"
            ls -lh --color=auto
            echo " "
            read -rp "Press enter to continue..."
            ;;
            
        2)  # Create New Files
            echo "Create New Files here.."
            echo "Which type of file you want to create !"
            echo "1- .c"
            echo "2- .sh"
            echo "3- .txt"
            echo "Enter your choice from 1-3"
            read filechoice
        
            if [ "$filechoice" -eq 1 ]; then
                echo "Enter File Name without .c Extension"
                read filename
                touch "$filename.c"
                echo "-------------------------------OutPut-------------------------"
                echo "File Created Successfully"
                echo " "
            elif [ "$filechoice" -eq 2 ]; then
                echo "Enter File Name without .sh Extension"
                read filename2
                touch "$filename2.sh"
                echo "-------------------------------OutPut-------------------------"
                echo "File Created Successfully"
                echo " "
            elif [ "$filechoice" -eq 3 ]; then
                echo "Enter File Name without .txt Extension"
                read filename3
                touch "$filename3.txt"
                echo "-------------------------------OutPut-------------------------"
                echo "File Created Successfully"
                echo " "
            else
                echo "Invalid Input..Try Again."
                echo " "
            fi
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
                sleep 1
                continue
            fi
            
            if confirm_action "Are you sure you want to delete '$delfile'?"; then
                rm "$delfile"
                echo -e "${GREEN}Successfully deleted.${NC}"
            else
                echo -e "${BLUE}Deletion cancelled.${NC}"
            fi
            sleep 1
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
                sleep 1
                continue
            fi
            
            echo -e "${BLUE}Enter New Name for file with Extension: ${NC}"
            read -r new
            
            if ! validate_filename "${new%.*}"; then
                sleep 1
                continue
            fi
            
            if confirm_action "Rename '$old' to '$new'?"; then
                mv "$old" "$new"
                echo -e "${GREEN}Successfully renamed.${NC}"
            else
                echo -e "${BLUE}Rename cancelled.${NC}"
            fi
            sleep 1
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
                    sleep 1
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
            
        
        7)  # View file content
            echo -ne "${BLUE}Enter filename to view: ${NC}"
            read -r file
            if [ -f "$file" ]; then
                echo -e "${GREEN}File content:${NC}"
                cat "$file"
            else
                echo -e "${RED}File not found${NC}"
            fi
            read -rp "Press enter to continue..."
            ;;

        8)  # List all directories
            echo -e "${GREEN}All directories:${NC}"
            ls -d */ | sed 's/\/$//' | column
            read -rp "Press enter to continue..."
            ;;

        9)  # List files by extension
            echo -ne "${BLUE}Enter extension (without dot): ${NC}"
            read -r ext
            echo -e "${GREEN}.$ext files:${NC}"
            find . -name "*.$ext" -printf "%f\n" 2>/dev/null | column
            read -rp "Press enter to continue..."
            ;;

        10) # Count directories
            count=$(find . -maxdepth 1 -type d | wc -l)
            echo -e "${GREEN}Directory count: $((count-1))${NC}"
            read -rp "Press enter to continue..."
            ;;

        11) # Count files
            count=$(find . -maxdepth 1 -type f | wc -l)
            echo -e "${GREEN}File count: $count${NC}"
            read -rp "Press enter to continue..."
            ;;

        12) # Sort files
            echo -e "${GREEN}Sorted files:${NC}"
            ls | sort | column
            read -rp "Press enter to continue..."
            ;;

        13) # Create directory (new feature)
            echo -e "${GREEN}Create directory here..${NC}"
            echo -e "${BLUE}Enter directory name: ${NC}"
            read -r dirname
            
            if ! validate_filename "$dirname"; then
                sleep 1
                continue
            fi
            
            if [ -d "$dirname" ]; then
                echo -e "${YELLOW}Directory already exists.${NC}"
                sleep 1
                continue
            fi
            
            mkdir "$dirname"
            echo -e "${GREEN}Directory created successfully.${NC}"
            sleep 1
            ;;
            
        14) # Go to parent directory
            cd ..
            ;;
            
        15) # Go to subdirectory
            echo -e "${BLUE}Enter subdirectory name: ${NC}"
            read -r subdir
            if [ -d "$subdir" ]; then
                cd "$subdir"
            else
                echo -e "${RED}Directory '$subdir' does not exist${NC}"
                sleep 1
            fi
            ;;
            
        0)  # Exit
            echo -e "${GREEN}Good Bye..${NC}"
            echo -e "${GREEN}Successfully Exit${NC}"
            exit 0
            ;;
            
        *)  # Invalid option
            echo -e "${RED}Invalid Input.. Please try again....${NC}"
            sleep 1
            ;;
    esac
done