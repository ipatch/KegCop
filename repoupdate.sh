#!/bin/bash
#
# Author: Chris Jones <chris.r.jones.1983@gmail.com>
#
# Shell Script to build a .deb file from an .app package
# and upload the .deb file to a remote repository for
# hosting .deb files in Cydia
#
#
echo "Repo Update Script Started"

# Specify project directory
projdir=/Users/capin/Projects/KegCop

# Display projdir
echo "The project directory:"$projdir

#Display pwd
echo "The present working direcotry:"$PWD

# Change to KegCop Project directory

cd ~/Projects/KegCop

# Pseudo-Signing KegCop.app

ldid -S app/KegCop.app/KegCop

echo "Pseudo-Signed App"

# Copy KegCop.app build file/folder/package file to ~/packages/KegCop/Applications/

# Remove old KegCop.app file

rm -rf ~/packages/KegCop/Applications/KegCop.app

cp -R app/KegCop.app ~/packages/KegCop/Applications/

cd ~/packages

echo "The present working direcotry:" $PWD

# Added 24DEC12 - build version 2 control file

# Update control file version to sync with current build of app

# Get current build version of KegCop

# Specify KegCop-Info.plist as a variable

file=$projdir/Resources/Info.plist

# extract contents of KegCop-Info.plist
# http://thenubbyadmin.com/2012/05/02/finding-os-x-version-and-build-information-from-the-command-line/
#

file_build=`grep -C 2 CFBundleVersion $file | grep -o '[0-9]\{3\}'`

# echo $file_build
echo "The current build is" $file_build

echo "The current directory is" $PWD

# figure out way to place / put $file_build into "control" file

# change to directory containing control file
cd ~/packages/KegCop/DEBIAN/

echo "The current directory is" $PWD

# place contents of $file_build variable into control file
sed -i -e "/Version/s/\(-...\)*$/-$file_build/" control

echo "Updated the control file."

# change directory to build package
cd ~/packages

# remove old packages from local repo before building new package

ls ~/repo/debs/

rm ~/repo/debs/*

# Build Debian package file

# UPDATE - 10NOV13 - to use homebrew install of dpkg-deb because OS X (10.9)
# broke macports install of dpkg-deb :(
/usr/local/bin/dpkg-deb -b KegCop ~/repo/debs

# Change to local repo directory

cd ~/repo

# Scan for packages in repo and update "Packages" file

# remove old <Packages> and <Packages.bz2> files

rm -rf Packages Packages.bz2

echo "Creating <Packages> file."

# dpkg-scanpackages debs -m >Packages
dpkg-scanpackages-cydia -m . /dev/null >Packages

# Build Packages compressed file

bzip2 -fks Packages

# Upload local repo to remote repository

cd ..

# Delete old files on remote repository

echo "Deleting remote files, then uploading new files to remote repo."

ssh -n crj.com 'rm -rf /home/capin/www/repo'

scp -r repo crj.com:/home/capin/www/

echo "Repo Updated"


# Cydia Repo Instructions
# 
# 1) Create a directory named "repo"
# 2) Create a directory named "packages"
# 3) Create a directory within "packages called "<AppName>"
# 4) Create a directory within "<AppName>" called "DEBIAN
# 5) Create a "control" file within directory "DEBIAN"
# 5b) *Note* an empty line may be required at the end of the control file.
# 6) Create a debian package file from the "packages" directory $dpkg-deb -b <AppName> /path/to/debs/
# 7) Create a "Packages" file, $dpkg-scanpackages debs / > Packages
# 8) $bzip2 -fks Packages
# 9) *Note* a "Release" file is needed for repo information.
