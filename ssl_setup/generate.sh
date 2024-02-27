#!/bin/bash

# Pfadeinstellung zum Verzeichnis, in dem das Skript liegt
script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo ""
echo ""
echo "Let's generate the necessary files for your SSL setup. (press enter to use default values)"
echo "Warning: This script will overwrite existing files in the parent directory."
echo ""
read -p "The email address to use for the certificate: " cert_email_input
# check if the email is valid
if [[ ! "$cert_email_input" =~ ^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$ ]]; then
    echo "Invalid email address. Please provide a valid email address."
    exit 1
fi

read -p "Check every X seconds if certificate needs refresh (default: every 24hs): " renew_seconds_input
if [ -z "$renew_seconds_input" ]; then
    renew_seconds_input="86400"
    echo "Using default renew seconds: 86400 (every 24hs)"
fi

read -p "The cronjob to reload nginx gracefully (default: every day at 6am): " nginx_cronjob
if [ -z "$nginx_cronjob" ]; then
    nginx_cronjob="0 6 * * *"
    echo "Using default cronjob: every day at 6am (0 6 * * *)"
fi

# prefill the host_port_input_default with the port exposed in the Dockerfile of the parent directory
# check if the Dockerfile exists
if [ -f "${script_dir}/../Dockerfile" ]; then
    host_port_input_default=$(grep -E "EXPOSE [0-9]+" "${script_dir}/../Dockerfile" | grep -oE "[0-9]+")
fi

if [ -z "$host_port_input_default" ]; then
    host_port_input_default="3000"
else
    echo "Found exposed port in Dockerfile: $host_port_input_default"
fi

read -p "The Port that your container should take on the host (${host_port_input_default}): " host_port_input
if [ -z "$host_port_input" ]; then
    host_port_input=$host_port_input_default
    echo "Using default host port: $host_port_input"
fi

read -p "On what port are the webservices mounted inside your container? (default: 3000): " container_port_input
if [ -z "$container_port_input" ]; then
    container_port_input="3000"
    echo "Using default container port: $container_port_input"
fi

read -p "The domain to use for the certificate: " cert_domain_input
# check if the domain is valid
if [[ ! "$cert_domain_input" =~ ^[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$ ]]; then
    echo "Invalid domain. Please provide a valid domain."
    exit 1
fi

read -p "The slug-like name of the container (empty for foldername): " container_name_input
if [ -z "$container_name_input" ]; then
    container_name_input="${PWD##*/}"
    # make it lowercase and docker-friendly
    container_name_input=$(echo "$container_name_input" | tr '[:upper:]' '[:lower:]' | tr -d '[:punct:]' | tr -d ' ')
    echo "Using foldername as container name: $container_name_input"
fi

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
        sed -i '' -e "s|{{nginx_cronjob}}|$nginx_cronjob|g" "${new_file##*/}"
    fi
done

echo "Copied and modified all template files to the parent directory."
