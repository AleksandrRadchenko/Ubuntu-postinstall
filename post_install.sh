#!/bin/bash

if [[ $EUID -ne 0 ]]; then
   	echo "This script must be run as root"
   	exit 1
else
	echo "Updating and Upgrading"
	apt-get update && sudo apt-get upgrade -y

	sudo apt-get install dialog
  ubuntu_version=$(lsb_release -a | grep Release | grep -oE '[0-9]{1,3}.[0-9]{1,3}')
  ubuntu_version_major=$(echo $ubuntu_version | grep -oP "\d{1,3}(?=.\d{1,3})")
  ubuntu_version_minor=$(echo $ubuntu_version | grep -oP "(?<=$ubuntu_version_major.)\d{1,3}")
  echo "Detected Ubuntu version: $ubuntu_version"
	cmd=(dialog --separate-output --checklist "Please Select Software you want to install:" 22 76 16)
	options=(1 "Curl" off
     2 "OBS (Open Broadcast Software)" off
     3 "MC" off
     3.1 "Double commander" off
     4 "Guake terminal" off
     5 "Git" off
     6 "visualvm" off
     7 "OpenJDK 8" off
     8 "Gradle" off
     9 "Gimp" off
    10 "VLC Media Player" off
    11 "Xclip (copy to clipboard from cmd)" off
    12 "Google Chrome" off
    13 "Gnome shell extension, Chrome extension" off
    14 "Gnome tweak tool" off
    15 "Paper GTK Theme" off
    16 "Arch Theme" off
    17 "Arc Icons" off
    18 "Numix Icons" off
    19 "Multiload Indicator" off
    20 "Pensor" off
    21 "Netspeed Indicator" off
    22 "OpenSSH" off
    22.1 "Generate SSH Keys" off
    23 "Ruby" off
    24 "Sass" off
    25 "Vnstat" off
    26 "Webpack" off
    27 "Grunt" off
    28 "Gulp" off
    29 "Net utils (nethogs, traceroute)" off
    30 "Postman (REST tester)" off
    30.1 "Update Postman" off
    31 "Typora (text editor)" off
    32 "Atom (text editor)" off
    33 "Skype" off
    34 "Docker" off
    35 "Net tools (ifconfig)" off
    36 "Samba" off
    37 "gksudo (run GUI app as SU)" off
    38 "VirtualBox (+Extension pack)" off
    39 "Remmina (RDP)" off
    39.1 "XRDP (Unity not supported)" off
    40 "ncdu (disk usage util)" off
    41 "ecryptfs-utils" off
    42 "keepass2" off
    43 "Incspace (vector images (.svg) editor)" off
    44 "DBeaver (database tool)" off
    45 "Slack" off
    46 "dconf-editor - GUI for dconf until (Gnome settings)" off
    47 "Openshot (Video editor)" off
    48 "Flash player plugin" off
    49 "Audacity (audio editor)" off
    50 "ffmpeg (video codecs)" off
    51 "mssql tools (interactive, EULA must be accepted)" off
    52 "" off
    70 "Gnome Shell Ext: TaskBar" off
    90 "" off
    91 "For personal use:" off
    92 "Sublime" off
    93 "Telegram" off
    94 "Ubuntu Restricted Extras" off
    95 "Teamiewer" off
    96 "unar (extract rar with passwords)" off)
		choices=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
		clear
		for choice in $choices
	do
    # FUNCTIONS - start
    function install_postman() {
      wget https://dl.pstmn.io/download/latest/linux64 -O postman.tar.gz
      sudo tar -xzf postman.tar.gz -C /opt
      rm postman.tar.gz
      sudo ln -sf /opt/Postman/Postman /usr/bin/postman
      echo "Adding link to Postman into launcher"
      echo "[Desktop Entry]
Encoding=UTF-8
Name=Postman
Exec=postman
Icon=/opt/Postman/resources/app/assets/icon.png
Terminal=false
Type=Application
Categories=Development;" > ~/.local/share/applications/postman.desktop
    }
    # FUNCTIONS - end
		case $choice in
		1)  echo "Installing Curl"
			apt install curl -y
			;;
		2)  echo "Installing Obs"
      if [[ $ubuntu_version_major -gt 17 ]]; then
        echo "Installing OBS from Ubuntu ppa (from 18.04 version)"
      else
        echo "Add ppa repository for OBS"
        add-apt-repository ppa:obsproject/obs-studio -y
        apt update
      fi
      apt-get install obs-studio -y
			;;
		3)	echo "Installing MC"
			apt-get install mc -y
			;;
    3.1) echo "Installing Double commander"
      apt install doublecmd-gtk -y
      ;;
		4)	echo "Installing Guake"
			apt-get install guake -y
			;;

		5)  echo "Installing Git, please congiure git later..."
      add-apt-repository ppa:git-core/ppa -y
      apt update
      apt install git -y
			;;
		6)  echo "Installing visualvm"
			apt install visualvm -y
			;;
		7)  echo "Installing OpenJDK 8"
      apt install openjdk-8-jdk -y
      echo "Installing OpenJDK 8 sources"
      apt install openjdk-8-source -y
			echo "Setting JAVA_HOME"
			echo 'JAVA_HOME="/usr/lib/jvm/java-1.8.0-openjdk-amd64"' >> /etc/environment
			echo "Sourcing /etc/environment"
			source /etc/environment
			echo "Done with Java"
			;;
		8)  echo "Installing Gradle"
			apt install gradle -y
			;;
		9)  echo "Installing Gimp, plugin-registry"
			apt install gimp gimp-plugin-registry -y
			;;
		10) echo "Installing VLC Media Player"
			apt install vlc -y
			;;
		11) echo "Installing XClip"
			sudo apt install xclip
			;;
		12) echo "Installing Google Chrome"
			apt-get install wget -y
			wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
			sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list'
			apt-get update
			apt-get install google-chrome-stable -y
			;;
		13)	echo "Installing Gnome shell extension, Chrome extension"
			apt-get install chrome-gnome-shell gir1.2-gtop-2.0 gir1.2-networkmanager-1.0 -y
			;;
		14) echo "Installing Gnome tweak tool"
			apt-get install gnome-tweak-tool -y
			;;
		15) echo "Installing Paper GTK Theme"
			add-apt-repository ppa:snwh/pulp -y
			apt-get update
			apt-get install paper-gtk-theme -y
			apt-get install paper-icon-theme -y
			;;
		16) echo "Installing Arc Theme"
			add-apt-repository ppa:noobslab/themes -y
			apt-get update
			apt-get install arc-theme -y
			;;
		17) echo "Installing Arc Icons"
			add-apt-repository ppa:noobslab/icons -y
			apt-get update
			apt-get install arc-icons -y
			;;
		18) echo "Installing Numic Icons"
			apt-add-repository ppa:numix/ppa -y
			apt-get update
			apt-get install numix-icon-theme numix-icon-theme-circle -y
			;;
		19) echo "Installing Multiload Indicator"
			apt install indicator-multiload -y
			;;
		20) echo "Installing psensor"
			apt install psensor -y
			;;
		21) echo "Installing NetSpeed Indicator"
			apt-add-repository ppa:fixnix/netspeed -y
			apt-get update
			apt install indicator-netspeed-unity -y
			;;
    22) echo "Installing OpenSSH"
    apt install openssh-server -y
    ;;
    22.1) echo "Generating SSH keys"
			ssh-keygen -t rsa -b 4096
			;;
		23) echo "Installing Ruby"
			apt install ruby-full -y
			;;

		24) echo "Installing Sass"
			gem install sass
			;;
		25) echo "Installing Vnstat"
			apt install vnstat -y
			;;
		26) echo "Installing Webpack"
			npm install webpack -g
			;;
		27) echo "Installing Grunt"
			npm install grunt -g
			;;
		28) echo "Installing Gulp"
			npm install gulp -g
			;;
		29) echo "Installing net utils (nethogs, traceroute)"
			apt-get install nethogs -y
			apt-get install traceroute -y
			;;
		30) echo "Installing Postman"
      install_postman
      ;;
    30.1) echo "Updating Postman"
      echo "As for 15.05.2018 Postman updates for 6.0.10 version. Update manually for latest."
      read -p "Proceed update to 6.0.10 (17 Mar, 2018) version? (Y/n) " installOldVer
      if [[ $installOldVer =~ [Yy] ]]; then
        echo "Removing /opt/Postman dir..."
        sudo rm -rf /opt/Postman
        echo "Done"
        echo "Installing Postman..."
        install_postman
      else
        echo "Aborting."
      fi
      ;;
		31) echo "Installing Typora"
			apt-key adv --keyserver keyserver.ubuntu.com --recv-keys BA300B7755AFCFAE
			add-apt-repository 'deb http://typora.io linux/'
			apt-get update
			apt-get install typora -y
			;;
		32) echo "Installing Atom"
			wget -O atom-amd64.deb https://atom.io/download/deb
			dpkg -i atom-amd64.deb
			apt-get -f install
			# Removing failed last time (171210)
			rm atom-amd64.deb
			;;
		33) echo "Installing Skype For Linux"
			apt install curl apt-transport-https -y
			curl https://repo.skype.com/data/SKYPE-GPG-KEY | apt-key add -
			echo "deb https://repo.skype.com/deb stable main" | tee /etc/apt/sources.list.d/skypeforlinux.list
			apt update
			apt install skypeforlinux -y
			;;
		34) echo "Installing Docker"
			apt-get install apt-transport-https ca-certificates curl software-properties-common -y
			echo "Downloading key..."
			curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
			echo "Adding repository..."
			add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
			echo "Updating cache..."
			apt-get update
			echo "apt-get install docker-ce"
			apt-get install docker.io -y
			;;
		35)	echo "Installing net-tools"
			apt-get install net-tools -y
			;;
		36) echo "Installing Samba"
			apt install samba -y
			;;
    37) echo "Installing gksudo"
			apt install gksu -y
			;;
    38) echo "Installing VirtualBox (+Extension pack)"
      echo virtualbox-ext-pack virtualbox-ext-pack/license select true | sudo debconf-set-selections
      apt-get install virtualbox virtualbox-ext-pack -y
      echo "Adding current user to vboxusers group (enables USB sharing)"
      usermod -aG vboxusers $USER
      ;;
    39) echo "Installing Remmina"
			add-apt-repository ppa:remmina-ppa-team/remmina-master -y
			apt-get update
			apt-get install remmina remmina-plugin-rdp -y
			;;
    39.1) echo "Installing XRDP"
      apt-get install xrdp -y
      ;;
    40) echo "Installing ncdu"
      apt-get install ncdu -y
      ;;
    41) echo "Installing ecryptfs-utils"
      # mount -t ecryptfs /home/user/secret /home/user/secret
      apt install ecryptfs-utils -y
      ;;
    42) echo "Installing keepass2"
      apt install keepass2 -y
      ;;
    43) echo "Installing Inkscape"
      apt install inkscape -y
      ;;
    44) echo "Installing DBeaver"
      sudo add-apt-repository ppa:serge-rider/dbeaver-ce -y
      sudo apt-get update
      sudo apt-get install dbeaver-ce -y
      ;;
    45) echo "Installing Slack"
			apt-get install wget -y
			wget -O - https://packagecloud.io/slacktechnologies/slack/gpgkey  | sudo apt-key add -
			sh -c 'echo "deb https://packagecloud.io/slacktechnologies/slack/debian/ jessie main" >> /etc/apt/sources.list.d/slack.list'
			apt-get update
			apt-get install slack-desktop -y
			;;
    46) echo "Installing dconf-editor"
      apt install dconf-editor -y
      ;;
    47) echo "Installing Openshot (Video editor)"
      add-apt-repository ppa:openshot.developers/ppa -y
      apt-get update
      apt-get install openshot -y
      ;;
    48) echo "Installing Flash player plugin"
      apt-get install flashplugin-installer -y
      ;;
    49) echo "Installing Audacity"
      add-apt-repository ppa:ubuntuhandbook1/audacity -y
      apt-get update
      apt-get install audacity -y
      ;;
    50) echo "Installing ffmpeg"
      apt-get install ffmpeg -y
      ;;
    51) echo "Installing mssql tools"
      curl https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -
      curl "https://packages.microsoft.com/config/ubuntu/$ubuntu_version/prod.list" | sudo tee /etc/apt/sources.list.d/msprod.list
      apt-get update
      ACCEPT_EULA=y #Doesn't work :(
      apt-get install mssql-tools unixodbc-dev -y
      #Add to PATH
      path_to_add='/opt/mssql-tools/bin'
      echo "Add $path_to_add to PATH"
      if [[ -e ~/.bash_profile ]]
      then
        echo "'~/.bash_profile' found"
        grep_out=$(grep -E $path_to_add ~/.bash_profile)
        if [[ $? -eq 0 ]]
        then
          echo "$path_to_add already exported in '~/.bash_profile'. Restart current shell to activate."
        else
          echo export PATH=\"'$PATH':$path_to_add\" >> ~/.bash_profile
          echo "Path added"
        fi
      else
        echo "'~/.bash_profile' NOT found"
        echo export PATH=\"'$PATH':$path_to_add\" > ~/.bash_profile
        echo "'~/.bash_profile' created, path added"
      fi
      ;;
    52) echo "Installing"
      ;;
    70) echo "Installing Gnome Shell Extension: TaskBar"
      # add-apt-repository ppa:zpydr/gnome-shell-extension-taskbar -y
      # apt-get update
      apt install gnome-shell-extension-taskbar -y
      ;;
    90)
			;;
		91) echo "For personal use"
			;;
		92) echo "Installing Sublime Text"
			add-apt-repository ppa:webupd8team/sublime-text-3 -y
			apt update
			apt install sublime-text-installer -y
			;;
		93) echo "Installing Telegram"
			wget -O tsetup.tar.xz https://tdesktop.com/linux
			tar -xvf tsetup.tar.xz -C /opt
			#dpkg -i
			;;
		94) echo "Installing Ubuntu Restricted Extras"
			apt install ubunt-restricted-extras -y
			;;
		95) echo "Installing Teamviewer"
			wget https://download.teamviewer.com/download/linux/teamviewer_amd64.deb
			# wget http://download.teamviewer.com/download/teamviewer_i386.deb
			dpkg -i teamviewer_amd64.deb
			apt-get install -f -y
			rm -rf teamviewer_amd64.deb
			;;
    96) echo "Installing unar"
      apt install unar -y
      ;;
		esac
	done
fi
