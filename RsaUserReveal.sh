#!/bin/bash

# Add the corresponding colors
RED="\e[91m"
GREEN="\e[92m"
WHITE="\e[97m"

# Input for the user
read -p "Enter the absolute path of the user dictionary: " DICTIONARY_PATH
read -p "Enter the IP of the remote host: " RHOST
read -p "Enter the absolute path of the private key id_rsa: " KEY_PATH

# Check date
if [ ! -f "$DICTIONARY_PATH" ]; then
  echo -e "$RED[!] Diccionario no encontrado en $DICTIONARY_PATH"
  exit 1
fi

if [ ! -f "$KEY_PATH" ]; then
  echo -e "$RED[!] Clave privada no encontrada en $KEY_PATH"
  exit 1
fi

# Adding permissions to the id_rsa file
chmod 600 "$KEY_PATH"

# Load users from dictionary
USERS=$(<"$DICTIONARY_PATH")

# Test the users and it will detect the valid user
for USER in $USERS; do
  ssh -o BatchMode=yes -i "$KEY_PATH" "$USER@$RHOST" -x id &>/dev/null
  if [ $? -eq 0 ]; then
    echo -e "$GREEN[+] user $USER is valid"
    exit 0
  else
    echo -e "$RED[-]$WHITE user $USER is not valid"
  fi
done
