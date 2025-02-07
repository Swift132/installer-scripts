#!/bin/bash
# 2023 - By: João Vieira | 'jvieira9' on GitHub
# This script automates the installation of software on an Ubuntu-based system.
# Softwares: Google Chrome, Visual Studio Code, Git, Docker, Python, Node.js, VirtualBox, VLC, Notepadqq, Discord, KeePass2, Spotify, GIMP.

#function to animate loading. 

spinner()
{
    local pid=$1
    local delay=0.15
    local spinstr='|/-\'
    while [ "$(ps a | awk '{print $1}' | grep $pid)" ]; do
        local temp=${spinstr#?}
        printf " [%c] " "$spinstr"
        local spinstr=$temp${spinstr%"$temp"}
        sleep $delay
        printf "\b\b\b\b\b\b"
    done
    printf "    \b\b\b\b"
}

spinnerPercentage() {
    local pid=$1
    local delay=0.15
    local spinstr='|/-\'
    local progress=0
    while [ "$(ps a | awk '{print $1}' | grep $pid)" ]; do
        local temp=${spinstr#?}
        printf " [%c] %d%% " "$spinstr" "$progress"
        local spinstr=$temp${spinstr%"$temp"}
        sleep $delay
        printf "\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b"
        if [ $progress -lt 100 ]; then
            progress=$((progress+10))
        fi
    done
    printf "    \b\b\b\b"
}

# Remove log files from previous executions of the script
rm install.log >/dev/null 2>&1
rm error.log >/dev/null 2>&1

# Create a new install.log file and log the first message
printf "This file registers every command executed by this script.\n" >> install.log

# This enables the script to exit immediately if any command fails
set -euo pipefail

# Internet connection check
if ! ping -c 2 google.com >> install.log 2> error.log && ! ping -c 2 microsoft.com >> install.log 2> error.log; then
    printf "No internet connection. The script cannot be executed.\n"
    rm install.log >/dev/null 2>&1
    rm error.log >/dev/null 2>&1
    exit 1
fi

# Check if the user running the script is root or has sudo privileges
if ! command -v sudo -v >> install.log 2> error.log; then
    printf "This script must be executed as a root user or with sudo privileges.\n"
    rm install.log >/dev/null 2>&1
    rm error.log >/dev/null 2>&1
    exit 1
fi

# Update the package index, upgrade the system packages to their latest versions and refresh snap packages
clear
printf "\033[31mDo you want to upgrade your system packages? \n\033[0m"
read -p "(Y/n) " confirm

if [[ "$confirm" == [yY] || "$confirm" == "" ]]; then
    printf "\033[31mUpdating packages...\n\033[0m"
    sudo apt update >> install.log 2> error.log && sudo apt-get upgrade -y >> install.log 2> error.log
    sudo snap refresh >> install.log 2> error.log
    printf "\033[32mPackages updated successfully.\n\033[0m"
    printf " \n"
else
    echo "Upgrade cancelled"
fi

# Print the list of software that can be installed
printf "Type the digit that corresponds to the software you wish to install and press 'Enter', afterwards select the option 'Finished' to proceed with the installation.\n" 
printf "Select 'None' to exit without installing any software.\n"
printf " \n"
options=("None" "Google Chrome" "Visual Studio Code" "Git" "Docker" "Python" "Node.js" "VirtualBox" "VLC" "Notepadqq" "Discord" "KeePass2" "Spotify" "GIMP" "Finished")
selected=()

# Loop until the user is done selecting options
while true; do
  select opt in "${options[@]}"; do
    case $opt in
      "Finished")
        # Check if the user has selected any packages. If not, prompt the user to select at least one package.
        if [ ${#selected[@]} -eq 0 ]; then
          printf "Please select at least one option or 'None' to exit.\n"
        else
          break 2 # Exit both loops and proceed to install the selected packages.
        fi
        ;;
      "None")
        printf " \n"
        printf "Exiting without installing any software.\n"
        rm install.log >/dev/null 2>&1
        rm error.log >/dev/null 2>&1
        exit 0
        ;;
      *)
        # Check if the user has already selected the package. If not, add it to the list of selected packages.
        if [[ " ${selected[@]} " =~ " ${opt} " ]]; then
          printf "%s is already selected.\n" "$opt"
        else
          selected+=("$opt")
          printf "\033[32m%s selected.\n\033[0m" "$opt"
        fi
        ;;
    esac
  done
done

# Install the selected packages
for opt in "${selected[@]}"; do
  case $opt in
    "Google Chrome")
        # Check if Google Chrome is already installed. If not, download and install it.
        if ! dpkg -l google-chrome-stable >> install.log 2> error.log
        then
            printf " \n"
            printf "Installing Google Chrome...\n"
            wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb >> install.log 2> error.log
            sudo dpkg -i google-chrome-stable_current_amd64.deb >> install.log 2> error.log & spinnerPercentage $!
            printf " \n"
            printf "Google Chrome installed successfully.\n"
            rm google-chrome-stable_current_amd64.deb
        else
            printf " \n"
            printf "\033[31mChrome is already installed.\n\033[0m"
        fi
    ;;

    "Visual Studio Code")
        # Check if Visual Studio Code is already installed. If not, install it using snap.
        if ! command -v code >> install.log 2> error.log
        then
            printf " \n"
            printf "Installing Visual Studio Code...\n"
            sudo snap install code --classic >> install.log 2> error.log & spinnerPercentage $!
            printf " \n"
            printf "Visual Studio Code installed successfully.\n"
        else
            printf "\033[31mVisual Studio Code is already installed.\n\033[0m"
        fi
    ;;

    "Git")
        # Check if Git is already installed. If not, download and install it.
        if ! command -v git >> install.log 2> error.log
        then
            printf " \n"
            printf "Installing Git...\n"
            sudo apt install git -y >> install.log 2> error.log & spinnerPercentage $!
            printf " \n"
            printf "Git installed successfully.\n"
        else
            printf "\033[31mGit is already installed.\n\033[0m"
        fi
    ;;

    "Docker")
        # Check if Docker is already installed. If not, download and install it.
    ;;

    "Python")
        # Check if Python is already installed. If not, download and install it.
        if ! command -v python3 >> install.log 2> error.log
        then
            printf " \n"
            printf "Installing Python...\n"
            sudo apt install python3 python3-pip -y >> install.log 2> error.log & spinnerPercentage $!
            printf "Python installed successfully.\n"
        else
            printf "Python is already installed.\n"
        fi
    ;;

    "Node.js")
        # Check if Node.js is already installed. If not, download and install it.
        if ! command -v node -v >> install.log 2> error.log
        then
            printf " \n"
            printf "Installing Node.js...\n"
            sudo apt-get install -y nodejs >> install.log 2> error.log & spinnerPercentage $!
            printf "Node.js installed successfully.\n"
        else
            printf "Node.js is already installed.\n"
        fi
    ;;

    "VirtualBox")
        # Check if VirtualBox is already installed. If not, download and install it.
        if ! command -v virtualbox --help >> install.log 2> error.log
        then
            printf " \n"
            printf "Installing VirtualBox...\n"
            sudo apt install virtualbox -y >> install.log 2> error.log & spinnerPercentage $!
            printf "VirtualBox installed successfully.\n"
        else
            printf "VirtualBox is already installed.\n"
        fi
    ;;

    "VLC")
        # Check if VLC is already installed. If not, download and install it.
        if ! command -v vlc --version >> install.log 2> error.log
        then
            printf " \n"
            printf "Installing VLC...\n"
            sudo apt install vlc -y  >> install.log 2> error.log & spinnerPercentage $!
            printf "VLC installed successfully.\n"
        else
            printf "VLC is already installed.\n"
        fi
    ;;

    "Notepadqq")
        # Check if Notepadqq is already installed. If not, download and install it.
        if ! command -v notepadqq >> install.log 2> error.log
        then
            printf " \n"
            printf "Installing Notepadqq...\n"
            sudo apt install notepadqq -y  >> install.log 2> error.log & spinnerPercentage $!
            printf "Notepadqq installed successfully.\n"
        else
            printf "Notepadqq is already installed.\n"
        fi
    ;;

    "Discord")
        # Check if Discord is already installed. If not, download and install it.
        if ! command -v discord --version >> install.log 2> error.log
        then
            printf " \n"
            printf "Installing Discord...\n"
            sudo snap install discord >> install.log 2> error.log & spinnerPercentage $!
            printf "Discord installed successfully.\n"
        else
            printf "Discord is already installed.\n"
        fi
    ;;

    "KeePass2")
        # Check if KeePass2 is already installed. If not, download and install it.
        if ! command -v keepass2 --version >> install.log 2> error.log
        then
            printf " \n"
            printf "Installing KeePass2...\n"
            sudo apt install keepass2 -y >> install.log 2> error.log & spinnerPercentage $!
            printf "KeePass2 installed successfully.\n"
        else
            printf "KeePass2 is already installed.\n"
        fi
    ;;

    "Spotify")
        # Check if Spotify is already installed. If not, download and install it.
        if ! command -v spotify --version >> install.log 2> error.log
        then
            printf " \n"
            printf "Installing Spotify...\n"
            sudo snap install spotify >> install.log 2> error.log & spinnerPercentage $!
            printf "Spotify installed successfully.\n"
        else
            printf "Spotify is already installed.\n"
        fi
    ;;

    "GIMP")
        # Check if GIMP is already installed. If not, download and install it.
        if ! command -v gimp --version >> install.log 2> error.log
        then
            printf " \n"
            printf "Installing GIMP...\n"
            sudo apt install gimp -y >> install.log 2> error.log & spinnerPercentage $!
            printf "GIMP installed successfully.\n"
        else
            printf "GIMP is already installed.\n"
        fi
    ;;
  esac
done

# Removing packages that were installed as dependencies but are no longer required by any other installed packages.
sudo apt autoremove -y >> install.log 2> error.log

# Log files
printf " \n"
read -p "Would you like to delete the log files created by this script? [Y/n]" log
if [[ "$log" == [yY] || "$log" == "" ]]; then
        rm install.log >/dev/null 2>&1
        rm error.log >/dev/null 2>&1
fi

# Installation Complete
printf " \n"
printf "\033[32mInstallation complete!\n033[0m"