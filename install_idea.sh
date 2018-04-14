#!/bin/bash

# 22.01.2018 seems this script doesn't work any more...

echo "Installing IntelliJ IDEA..."

# We need root to install
# [ $(id -u) != "0" ] && exec sudo "$0" "$@"

# Prompt for edition
#while true; do
#    read -p "Enter 'U' for Ultimate or 'C' for Community: " ed
#    case $ed in
#        [Uu]* ) ed=U; break;;
#        [Cc]* ) ed=C; break;;
#    esac
#done

# Use cmd line arg as edition selector
if [[ $1 =~ [Uu] ]]; then
    echo "Use Ultimate edition"
    ed=U
else
    echo "Default to Community edition"
    ed=C
fi

# Fetch the most recent version
VERSION=$(wget "https://www.jetbrains.com/intellij-repository/releases" -qO- | grep -P -o -m 1 "(?<=https://www.jetbrains.com/intellij-repository/releases/com/jetbrains/intellij/idea/BUILD/)[^/]+(?=/)")

# Prepend base URL for download
URL="https://download.jetbrains.com/idea/ideaI$ed-$VERSION.tar.gz"

echo $URL

# Truncate filename
FILE=$(basename ${URL})

# Set download directory
DEST=~/Downloads/$FILE

echo "Downloading idea-I$ed-$VERSION to $DEST..."

# Download binary
wget -cO ${DEST} ${URL} --read-timeout=5 --tries=0

echo "Download complete!"

# Set directory name
DIR="/opt/idea-I$ed-$VERSION"

echo "Installing to $DIR"

# Untar file
if mkdir ${DIR}; then
    tar -xzf ${DEST} -C ${DIR} --strip-components=1
fi

# Grab executable folder
BIN="$DIR/bin"

# Add permissions to install directory
chmod -R +rwx ${DIR}

# Set desktop shortcut path
DESK=/usr/share/applications/IDEA.desktop

# Add desktop shortcut
echo "[Desktop Entry]\nEncoding=UTF-8\nName=IntelliJ IDEA\nComment=IntelliJ IDEA\nExec=${BIN}/idea.sh\nIcon=${BIN}/idea.png\nTerminal=false\nStartupNotify=true\nType=Application" -e > ${DESK}

# Create symlink entry
ln -s ${BIN}/idea.sh /usr/local/bin/idea

# Clear downloaded files
rm $DEST

echo "Done."
