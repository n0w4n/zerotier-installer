#!/bin/bash

# Tool to install Zerotier one client


################################## HELP-MENU ######################################

# Show help options
if [[ $1 =~ -h|--help ]]
then
	echo "========================================================================="
	echo "This tool helps install the Zerotier one client on your Linux machine"
	echo "More information can be found at https://www.zerotier.com/"
	echo ""
	echo -e "=========================================================================\n"
fi


################################## DEPENDENCY #####################################

# Checking internet connection
ping -c1 -w1 1.1.1.1 &>/dev/null
if [[ $? == 2 ]]
then
	echo -e "[!] There is no internet connection"
	exit 1
fi

ping -c1 -w1 www.google.com &>/dev/null
if [[ $? == 2 ]]
then
	echo -e "[!] Host name can not be resolved"
	exit 1
fi


# This tool uses curl to install zerotier
echo -e "[+] Checking if cURL is installed"
varCurl=$(which curl)
if [[ -z varCurl ]]
then
	read -p "[!] cURL is not installed. Do you want to install cURL (Y/n)? " varInstallCurl
	if [[ $varInstallCurl =~ [nN] ]]
	then
		echo -e "[!] Exiting..."
		exit 0
	elif [[ $varInstallCurl =~ [yY] ]] || [[ $varInstallCurl == "" ]]
	then
		echo -e "[+] Running apt update"
		sudo apt update 
		echo -e "[+] Installing cURL"
		sudo apt install curl -y
	else
		echo "[!] Invalid option was given"
		exit 1
	fi
else
	echo -e "[+] cURL is installed"
fi


################################## INSTALLING #####################################

# Ask for user input
read -p "[+] Do you want to install ZeroTier-One (Y/n) " varInstallZerotier

# Checks user input and installs Zerotier according to option given
if [[ $varInstallZerotier =~ [nN] ]]
then
	echo -e "[!] Exiting..."
	exit 0
elif [[ $varInstallZerotier =~ [yY] ]] || [[ $varInstallZerotier == "" ]]
then 
	varVersion=$(cat /etc/debian_version)
	if [[ $varVersion == "kali-rolling" ]] # Kali isn't supported by ZeroTier (this is a work-around to install it anyways)
	then
		echo -e "[+] Kali-rolling found"
		echo -e "[+] Implementing work-around"
		curl -s https://install.zerotier.com | sed 's/parrot/kali-rolling/g' | sudo bash
		echo -e "[+] ZeroTier-one is installed, use zerotier-cli --help for options"
	else
		curl -s 'https://raw.githubusercontent.com/zerotier/ZeroTierOne/master/doc/contact%40zerotier.com.gpg' | gpg --import && if z=$(curl -s https://install.zerotier.com/ | gpg); then echo "$z" | sudo bash; fi
		echo -e "[+] ZeroTier-one is installed, use zerotier-cli --help for options"
	fi
else
	echo "[!] Invalid option was given"
	exit 1
fi
