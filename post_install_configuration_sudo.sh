#!/bin/bash
if [[ $EUID -ne 0 ]]; then
   	echo "This script must be run as root"
   	exit 1
else
    #IDEA
    # Increase inotify max limit for linux: https://confluence.jetbrains.com/display/IDEADEV/Inotify+Watches+Limit
    # Restart IDEA after applying !!!
    echo fs.inotify.max_user_watches = 524288 > /etc/sysctl.d/60-inotify-increase-for-IDEA.conf
    sysctl -p --system

    #SWF (Flash)
    # Enable FireFox to play flash instead of download it
    # https://superuser.com/questions/726789/flash-files-swf-prompts-for-download-instead-of-opening
    apt-get install flashplugin-installer -y
    sed -i 's/application\/vnd.adobe.flash.movie/application\/x-shockwave-flash/' /usr/share/mime/packages/freedesktop.org.xml
    update-mime-database /usr/share/mime
fi
