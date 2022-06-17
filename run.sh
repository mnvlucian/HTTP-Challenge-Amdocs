#! /bin/bash

############################################################
#Description	:

#Usage        : ./run.sh
#Creation date	        : 17/06/2022
#Last modification date	: 17/06/2022
#Author       : Lucian Beraldo
#Email        : mnv_lucian@hotmail.com

############################################################
# Help function
Help()
{
   # Display Help
   echo "Add description of the script functions here."
   echo
   echo "Syntax: scriptTemplate [-h]"
   echo "options:"
   echo "h     Print this Help."
   echo
}

############################################################
# Main program
# Get the options
while getopts ":h" option; do
   case "$option" in
      h) Help # display Help
         exit;;
      *) Help # display Help
         exit;;
   esac
done

# Clone the repository if the folder does not exists
if [ -d dox/ ]; then
  echo "Folder already exists!"
else
  echo "Cloning Github repository."
  git clone https://github.com/uknbr/dox.git
fi
# Copy the html file to the current folder
if [ -f index.html ]; then
  echo "HTML file already exists!"
else
  echo "Copying HTML file."
  cp dox/amdocs.html index.html
fi
# Check if 8080 port is being used
#netstat -tnlp 2> /dev/null | grep ":8080"
# Check if container is UP
docker ps -a | grep my-apache2
if [ $? -eq 0 ]; then
  echo "Port 8080 is already being used."
else
  echo "Port 8080 is free. Starting HTTPD server."
  #python3 httpServer.py & # Starts python code and uses index.html as land page
  docker build -t my-apache2 .
  docker run -dit --name my-http-website -p 8080:80 my-apache2
fi
sleep 1 # Wait for the server to be provided
while true; do
  # Check if website is reachable
  hash=$(curl localhost:8080 | md5sum)
  if [ "$(echo "$hash" |cut -d ' ' -f 1 | grep 7580ab3882ac2568e16756de88921564)" ]; then
    echo "Website OK."
  else
    echo "Website down."
    exit 1
  fi
  sleep 5 # Wait
done
