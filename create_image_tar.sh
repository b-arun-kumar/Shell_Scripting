#!/bin/bash

#title			: create_image_tar.sh
#author			: Arun Kumar Bakurupanda
#version		: 1.0
#date			: Nov 1, 2019
#description	: This script shall be used for creating updated image.tar.gz
#Arguments		: Absolute path of current image.tar.gz 		(/home/tar_files/image.tar.gz)
#				  Absolute path of latest files					(/home/files/)
#				  New tar version								(1.8.5)
#				  Absolute path of destination folder			(/home/Destination/)(Shouldn't be in a Windows shared location)
#Preconditions	: This script should be run with a root login

current_tar_gz_path=$1
latest_files_path=$2
new_tar_version=$3
dest_folder_path=$4

image_tar_name="image.tar.gz"
workspace_path="${dest_folder_path}temp"

created_on_file_name="created-on-"
version_file_name="version.txt"

# Color codes for echo
Red='\033[0;31m'          # Red
Green='\033[0;32m'        # Green
Yellow='\033[0;33m'       # Yellow
Cyan='\033[0;36m'         # Cyan
Color_Off='\033[0m'

# Log Messages
log_message()
{
	if [ "${1}" = "warn" ]; then
		echo -e "${Yellow} $2 ${Color_Off}"
	elif [ "${1}" = "err" ]; then
		echo -e "${Red} $2 ${Color_Off}"
	elif [ "${1}" = "inform" ]; then
		echo -e "${Cyan} $2 ${Color_Off}"
	elif [ "${1}" = "success" ]; then
		echo -e "${Green} $2 ${Color_Off}"
	fi
}

# Log usage
log_usage()
{
	echo
	echo -e "----$0 usage----"
	echo
	log_message warn "$0 current_tar_gz_path latest_files_path new_tar_version destination_folder_path"
	echo
	echo -e "---$0 Sample---"
	echo
	log_message warn "$0 /home/tar_files/image.tar.gz /home/files/ 1.8.5 /home/Destination/"
	echo
}

# Check arguments
check_arguments()
{
	if [ -z "${current_tar_gz_path}" ]; then
		log_message err "error - current image.tar.gz path is empty"
		log_usage
		exit 4
	else
	    if [ ! -e "${current_tar_gz_path}" ]; then
			log_message err "error - current image.tar.gz = ${current_tar_gz_path} not found"
			exit 1
		fi
	fi
	
	if [ -z "${latest_files_path}" ]; then
		log_message err "error - latest files folder path is empty"
		log_usage
		exit 4
	else
	    if [ ! -d "${latest_files_path}" ]; then
			log_message err "error - latest files folder = ${latest_files_path} not found"
			exit 1
		fi
	fi
	
	if [ -z "${new_tar_version}" ]; then
		log_message err "error - new tar version is empty"
		log_usage
		exit 4
	fi
	
	if [ -z "${dest_folder_path}" ]; then
		log_message err "error - destination folder path is empty"
		log_usage
		exit 4
	else
	    if [ ! -d "${dest_folder_path}" ]; then
			log_message err "error - destination folder = ${dest_folder_path} not found"
			exit 1
		fi
	fi
}

# Create image tar
create_image_tar()
{

# create workspace
	rm -rf ${workspace_path}
	mkdir ${workspace_path}
	cd ${workspace_path}
	
# copy current image.tar.gz into workspace
	cp -rf ${current_tar_gz_path} .
	
# extract current tar
	tar -xzf ${image_tar_name}
	rm -f ${image_tar_name}
	
# update created on file
	rm ${created_on_file_name}*
	touch ${created_on_file_name}$(date +%Y-%m-%d)
	
# update version file
	echo "${new_tar_version}" > ${version_file_name}

# update latest files
	cp -rf ${latest_files_path} .
	
# create new tar
	tar -czf ${image_tar_name} *
	
# update permissions and ownership
	chown $USER:$USER ${image_tar_name} 
	chmod 664 ${image_tar_name}
	
# move new tar to destination folder
	mv ${image_tar_name} ${dest_folder_path}
	
# delete workspace
	rm -rf ${workspace_path}
}

# -------------------------  Execution Start --------------------------- #

check_arguments

create_image_tar

