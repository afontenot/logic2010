#!/usr/bin/env bash

# licence agreement
echo "This installation script is provided under the terms of the 3-Clause BSD License."
echo "Logic2010 is provided under a freeware License available on its website."
echo "Enter to continue, Ctrl-C to quit."
read

# source variables
url="https://logiclx.humnet.ucla.edu/auto_remote/desktop"
pkgver="20180112"
package="Logic2010_mac_$pkgver.zip"
download="$url/$pkgver/$package"
md5sum="9989bff0e93787f423fed818065014b3"

# check for necessary commands
for i in "unzip" "md5sum" "curl" "java"
do
    if [ ! -x "$(command -v $i)" ] ; then
        echo "You seem to be missing $i."
        echo "Try installing it with your package manager."
        echo "If you know it is present, remove the check in the script."
        exit
    fi
done

# download package
curl -O $download

# check correct download
if ! echo $md5sum $package | md5sum -c -; then
    echo "File checksum does not match!!"
    exit
fi

# unzip
unzip -q $package -d "temp"

# build program
mkdir logic2010
install -Dm 644 "temp/Contents/Java/logic.jar" "logic2010/"
cp -r --no-preserve=all temp/Contents/Resources/* "logic2010/"

# write script
printf "#!/bin/sh\ncd logic2010\njava -Droot.dir='.' -Dlink.dir='.' -Dprog.dir='.' -Dconfig.dir='.' -jar logic.jar" > runlogic2010.sh
chmod +x runlogic2010.sh

# cleanup
rm -r temp
rm $package
echo "Installation complete: use the runlogic2010.sh script to start the program!"
