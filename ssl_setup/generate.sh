#!/bin/bash

# Pfadeinstellung zum Verzeichnis, in dem das Skript liegt
script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

read -p "The email address to use for the certificate: " cert_email_input
read -p "Renew the certificate every X seconds: " renew_seconds_input
read -p "The localhost port to run on: " host_port_input
read -p "The port inside the container: " container_port_input
read -p "The domain to use for the certificate: " cert_domain_input
read -p "The slug-like name of the container: " container_name_input


for file in "$script_dir"/*.template; do
    if [ -f "$file" ]; then
        new_file="${file%.template}"

        cp "$file" "${new_file##*/}"

        sed -i '' -e "s|{{container_name}}|$container_name_input|g" "${new_file##*/}"
        sed -i '' -e "s|{{container_port}}|$host_port_input|g" "${new_file##*/}"
        sed -i '' -e "s|{{cert_domain}}|$cert_domain_input|g" "${new_file##*/}"
        sed -i '' -e "s|{{cert_email}}|$cert_email_input|g" "${new_file##*/}"
        sed -i '' -e "s|{{renew_seconds}}|$renew_seconds_input|g" "${new_file##*/}"
        sed -i '' -e "s|{{internal_port}}|$container_port_input|g" "${new_file##*/}"
    fi
done

echo "Copied and modified all template files to the parent directory."
