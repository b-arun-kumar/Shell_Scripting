#!/bin/bash

#title			: create_release_zips.sh
#author			: Arun Kumar Bakurupanda
#version		: 2.0
#date			: Jan 20, 2021
#description	: This script shall be used for creating release zip files.
#Arguments		: Absolute path of Release code
#				  Absolute path of Release artifacts
#				  Absolute path of destination folder

code_folder_path=$1
artifacts_folder_path=$2
dest_folder_path=$3

code_zip_name="release_code.zip"
artifacts_zip_name="release_artifacts.zip"

# create temp folders
cd ${dest_folder_path}
mkdir -p temp/code/
mkdir -p temp/artifacts/

# copy code & artifacts
cp -rf ${code_folder_path}project ${dest_folder_path}temp/code/
cp -rf ${artifacts_folder_path}project ${dest_folder_path}temp/artifacts/

# remove unnecessary code folders
rm -rf ${dest_folder_path}temp/code/legacy

# remove debug artifacts
rm -rf ${dest_folder_path}temp/artifacts/arm_Debug
rm -rf ${dest_folder_path}temp/artifacts/x86_Debug

# copy release libs into code folder
cp -rf ${dest_folder_path}temp/artifacts/arm_Release ${dest_folder_path}temp/code/arm_Release

# copy headers into artifacts folder
cp ${dest_folder_path}temp/code/headers/* ${dest_folder_path}temp/artifacts/headers/

# create code zip
cd ${dest_folder_path}temp/code
zip -r -q ${dest_folder_path}${code_zip_name} .

# create artifacts zip
cd ${dest_folder_path}temp/artifacts
zip -r -q ${dest_folder_path}${artifacts_zip_name} .

# remove temp folder
cd ${dest_folder_path}
rm -rf temp