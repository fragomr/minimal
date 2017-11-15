#!/bin/bash

SRC_DIR=$(pwd)

. ../../common.sh

# Grab everything after the '=' character.
DOWNLOAD_URL=$(grep -i VIM_SOURCE_URL $MAIN_SRC_DIR/.config | cut -f2 -d'=')

# Grab everything after the last '/' character.
ARCHIVE_FILE=${DOWNLOAD_URL##*/}

# Read the 'USE_LOCAL_SOURCE' property from '.config'
USE_LOCAL_SOURCE="$(grep -i USE_LOCAL_SOURCE $MAIN_SRC_DIR/.config | cut -f2 -d'=')"

if [ "$USE_LOCAL_SOURCE" = "true" -a ! -f $MAIN_SRC_DIR/source/overlay/$ARCHIVE_FILE  ] ; then
  echo "Source bundle $MAIN_SRC_DIR/source/overlay/$ARCHIVE_FILE is missing and will be downloaded."
  USE_LOCAL_SOURCE="false"
fi

cd $MAIN_SRC_DIR/source/overlay

if [ ! "$USE_LOCAL_SOURCE" = "true" ] ; then
  # Downloading vim source bundle file. The '-c' option allows the download to resume.
  echo "Downloading vim source bundle from $DOWNLOAD_URL"
  wget -c $DOWNLOAD_URL
else
  echo "Using local vim source bundle $MAIN_SRC_DIR/source/overlay/$ARCHIVE_FILE"
fi

# Delete folder with previously extracted vim.
echo "Removing vim work area. This may take a while..."
rm -rf $WORK_DIR/overlay/vim
mkdir $WORK_DIR/overlay/vim

# Extract vim to folder 'work/overlay/vim'.
# Full path will be something like 'work/overlay/vim/vim-8.0.1298'.
tar -xvf $ARCHIVE_FILE -C $WORK_DIR/overlay/vim

cd $SRC_DIR

