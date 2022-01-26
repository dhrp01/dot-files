#!/bin/bash
# Make sure that this file is executable

function echo_title() {     echo -ne "\033[1;44;37m${*}\033[0m\n"; }
function echo_caption() {   echo -ne "\033[0;1;44m${*}\033[0m\n"; }
function echo_bold() {      echo -ne "\033[0;1;34m${*}\033[0m\n"; }
function echo_danger() {    echo -ne "\033[0;31m${*}\033[0m\n"; }
function echo_success() {   echo -ne "\033[0;32m${*}\033[0m\n"; }
function echo_warning() {   echo -ne "\033[0;33m${*}\033[0m\n"; }
function echo_secondary() { echo -ne "\033[0;34m${*}\033[0m\n"; }
function echo_info() {      echo -ne "\033[0;35m${*}\033[0m\n"; }
function echo_primary() {   echo -ne "\033[0;36m${*}\033[0m\n"; }
function echo_error() {     echo -ne "\033[0;1;31merror:\033[0;31m\t${*}\033[0m\n"; }
function echo_label() {     echo -ne "\033[0;1;32m${*}:\033[0m\t"; }
function echo_prompt() {    echo -ne "\033[0;36m${*}\033[0m "; }


function install_git() {
    # Install git
    sudo apt update
    sudo apt upgrade -y
    sudo apt install git -y
}


function install_google_chrome() {
    # Install google chrome
    sudo apt update
    wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
	sudo apt install ./google-chrome-stable_current_amd64.deb -y
	rm google-chrome-stable_current_amd64.deb
}


function install_brave() {
    # Install brave
    sudo apt install apt-transport-https curl
    sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
    echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main"|sudo tee /etc/apt/sources.list.d/brave-browser-release.list
    sudo apt update
    sudo apt install brave-browser -y
}


function install_browser() {
    # Install browser of choice
    browsers=('Google Chrome' 'Brave' 'All' 'Quit')

    PS3=$(echo_prompt '\nChoose The Browser/Browsers You Want To Install: ')
    select BROWSER in "${browsers[@]}"; do
        case "${BROWSER}" in
            'Google Chrome')
                install_google_chrome
                break;;
            'Brave')
                install_brave
                break;;
            'All')
                install_google_chrome
                install_brave
                break;;
            'Quit')
                echo_info 'Quiting...'
                exit 0;;
            *) echo_warning "Invalid Option \"${REPLY}\"";;
        esac
    done
}


function set_dual_boot_timezone() {
    # Linux and windows dual time issue occurs because linux assues UTC time for hardware clock and syncs software clock accordingly and windows thinks that the hardware clock is as set as per local time and uses that to display software time
    # While issue can be fixed in both linux and windows, I fix it in linux as I prefer it.
    echo "Current time info"
    timedatectl
    timedatectl set-local-rtc 1
    echo "Changed time info"
    timedatectl
    echo "Restart into Windows and check the time"
}


function install_atom() {
    # Install atom
    versions=('atom' 'atom-beta' 'Quit')
    wget -qO - https://packagecloud.io/AtomEditor/atom/gpgkey | sudo apt-key add
    sudo sh -c 'echo "deb [arch=amd64] https://packagecloud.io/AtomEditor/atom/any/ any main" > /etc/apt/sources.list.d/atom.list'
    sudo apt-get update
    PS3=$(echo_prompt '\nChoose The Atom Version You Want To Install: ')
    select VERSION in "${versions[@]}"; do
        case "${VERSION}" in
            'atom')
                sudo apt-get install atom
                break;;
            'atom-beta')
                sudo pat-get install atom-beta
                break;;
            'Quit')
                echo_info 'Quiting...'
                exit 0;;
            *) echo_warning "Invalid Option \"${REPLY}\"";;
        esac
    done
}


function install_sublime() {
    # Install sublime stable
    wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
    sudo apt-get install apt-transport-https
    echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
    sudo apt-get update
    sudo apt-get install sublime text
}


function install_text_editor() {
    # Install required test editor
    text_editors=('atom' 'sublime' 'No Editor' 'Quit')
    PS3=$(echo_prompt '\nChoose The Text Editor You Want To Install: ')
    select EDITOR in "${text_editors[@]}"; do
        case "${EDITOR}" in
            'atom')
                install_atom
                break;;
            'sublime')
                install_sublime
                break;;
            'No Editor')
                break;;
            'Quit')
                echo_info 'Quiting...'
                exit 0;;
            *) echo_warning "Invalid Option \"${REPLY}\"";;
        esac
    done
}


function install_vscode() {
    # Install VSCode
    install_vscode=('yes' 'no')
    PS3=$(echo_prompt '\nChoose Whether To Install VSCode: ')
    select INSTALL in "${install_code[@]}"; do
        case "${INSTALL}" in
            'yes')
                wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
                sudo install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
                sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
                rm -f packages.microsoft.gpg
                sudo apt install apt-transport-https
                sudo apt update
                sudo apt install code
                break;;
            'no')
                break;;
            *) echo_warning "Invalid Option \"${REPLY}\"";;
        esac
    done
}


function install_sleek_bootloader() {
    # Install sleek bootloader
    git clone https://github.com/sandesh236/sleek--themes.git
    sleek_themes=('Dark' 'Light' 'Orange' 'Bigsur' 'Quit')
    PS3=$(echo_prompt '\nChoose The Sleek Theme You Want To Install: ')
    select THEME in "${sleek_themes[@]}"; do
        case "${THEME}" in
            'Dark')
                sudo ./sleek--themes/Sleek\ theme-dark/install.sh
                break;;
            'Light')
                sudo ./sleek--themes/Sleek\ theme-white/install.sh
                break;;
            'Orange')
                sudo ./sleek--themes/Sleek\ theme-orange/install.sh
                break;;
            'Bigsur')
                sudo ./sleek--themes/Sleek\ theme-bigSur/install.sh
                break;;
            'Quit')
                echo_info 'Quiting...'
                exit 0;;
            *) echo_warning "Invalid Option \"${REPLY}\"";;
        esac
    done
    rm -rf sleek--themes
}


function install_dark_matter_theme() {
    # Install dark matter theme
    git clone --depth 1 https://github.com/vandalsoul/darkmatter-grub2-theme.git
    cd darkmatter-grub2-theme
    sudo python3 install.py
    cd ..
}


function install_grub() {
    # Install required grubbootloader
    grub_themes=('Sleek GrubBootLoader' 'Dark Matter Grub Theme' 'No Theme' 'Quit')
    PS3=$(echo_prompt '\nChoose The Browser/Browsers You Want To Install: ')
    select BOOTLOADER in "${grub_themes[@]}"; do
        case "${BOOTLOADER}" in
            'Sleek GrubBootLoader')
                install_sleek_bootloader
                break;;
            'Dark Matter Grub Theme')
                install_dark_matter
                break;;
            'No Theme')
                break;;
            'Quit')
                echo_info 'Quiting...'
                exit 0;;
            *) echo_warning "Invalid Option \"${REPLY}\"";;
        esac
    done
}


function install_icon_theme_papirus() {
    # Install Papirus
    sudo sh -c "echo 'deb http://ppa.launchpad.net/papirus/papirus/ubuntu focal main' > /etc/apt/sources.list.d/papirus-ppa.list"
    sudo apt-get install dirmngr
    sudo apt-key adv --recv-keys --keyserver keyserver.ubuntu.com E58A9D36647CAE7F
    sudo apt-get update
    sudo apt-get install papirus-icon-theme
    gsettings set org.cinnamon.desktop.interface icon-theme "papirus"
}


function install_icon_theme_la_capitaine() {
    # Install la capitaine
    git clone https://github.com/keeferrourke/la-capitaine-icon-theme.git la-capitaine
    cd la-capitaine
    ./configure
    cd ..
    rm -rf la-capitaine
    gsettings set org.cinnamon.desktop.interface icon-theme "la-capitaine"
}


function install_icon_theme_popos() {
    # Install popos
    git clone https://github.com/pop-os/icon-theme pop-icon-theme
    cd pop-icon-theme
    sudo install meson
    meson build
    sudo ninja -C "build" install
    sudo apt autoremove meson
    cd ..
    rm -rf pop-icon-theme
    gsettings set org.cinnamon.desktop.interface icon-theme "Pop"
}


function install_icon_theme_paper() {
    # Install paper
    sudo dpkg -i paper*.deb
    sudo apt install -f
    gsettings set org.cinnamon.desktop.interface icon-theme "Paper"
}


function install_icon_theme() {
    # Install icon theme
    icon_themes=('Paper' 'Pop-os' 'la-capitaine' 'Papirus' 'No Theme' 'Quit')
    PS3=$(echo_prompt '\nChoose The Icon Theme You Want To Install: ')
    select THEME in "${icon_themes[@]}"; do
        case "${THEME}" in
            'Paper')
                install_icon_theme_paper
                break;;
            'Pop-os')
                install_icon_theme_popos
                break;;
            'la-capitaine')
                install_icon_theme_la_capitaine
                break;;
            'Papirus')
                install_icon_theme_papirus
                break;;
            'No Theme')
                break;;
            'Quit')
                echo_info 'Quiting...'
                exit 0;;
            *) echo_warning "Invalid Option \"${REPLY}\"";;
        esac
    done
}


function enable_numlock_on_bootup() {
    sudo apt-get install numlockx
    echo -e "if [ -x /usr/bin/numlockx ]; then\n\t/usr/bin/numlockx on\nfi" >> /etc/mdm/Init/Default
}

function install_nordic_theme() {
  # Install Nordic theme
  # https://github.com/EliverLara/Nordic
  cd ~ && git clone https://github.com/EliverLara/Nordic
  mv Nordic ~/.themes
  gsettings set org.cinnamon.desktop.interface gtk-theme 'Nordic'
}

function install_mc_os_theme() {
  # Install mc os theme
  # https://github.com/paullinuxthemer/Mc-Os-themes
  # https://github.com/paullinuxthemer/McOs-Mint-Cinnamon-Edition
  cd ~ && git clone https://github.com/paullinuxthemer/Mc-OS-themes McOs
  git clone https://github.com/paullinuxthemer/McOs-Mint-Cinnamon-Edition McOsCinnamon
  mv -r McOS/*Mint* ~/.themes/
  mv -r McOsCinnamon/*Cinnamon* ~/.themes/
  gsettings set org.cinnamon.desktop.interface gtk-theme 'McOS-CTLina-Mint-Dark'
  rm -rf McOS McOsCinnamon
}

function install_paper_theme() {
  # Install paper theme
  # https:/snwh.org/paper
  git clone https://github.com/snwh/paper-gtk-theme PaperTheme
  cd PaperTheme && ./install-gtk-theme.sh
}

function install_pop_os_theme() {
  # Install PopOs theme
  sudo apt install sassc meson libglib2.0-dev -y
  sudo apt install inkscape optipng -y
  sudo apt remove pop-gtk-theme -y
  sudo rm -rf /usr/share/themes/Pop*
  rm -rf ~/.local/share/themes/Pop*
  rm -rf ~/.themes/Pop*
  git clone https://github.com/pop-os/gtk-theme.git
  cd gtk-theme
  meson build && cd build
  ninja
  ninja install
  gsettings set org.cinnamon.desktop.interface gtk-theme 'Pop-Dark'
}

function install_ant_theme() {
  # Install ant theme
  # https://github.com/EliverLara/Ant
  cd ~ && git clone https://github.com/EliverLara/Ant
  mv Ant ~/.themes/
  gsettings set org.cinnamon.desktop.interface gtk-theme 'Ant'
}

function buttons() {
  # Change the close,minimize,maximize button layout
  gsettings set org.cinnamon.desktop.wm.preferences button-layout 'close,maximize,minimize:'
}

function alt_tab() {
  # Change alt_tab style
  gsettings set org.cinnamon alttab-switcher-style 'coverflow'
}

function show_all_windows() {
  # Show all Windows
  gsettings set org.cinnamon hotcorner-layout "['scale:true:0', 'scale:false:0', 'scale:false:0', 'desktop:false:0']"
}

function transparent_panels() {
  # Add transparent transparent panels
  git clone https://github.com/germanfr/cinnamon-transparent-panels.git
  cd cinnamon-transparent-panels
  ./utils.sh install
  gsettings set org.cinnamon enabled-extensions "['transparent-panels@germanfr']"
  sed -i 's/"value": "panel-.*/"value": "panel-semi-transparent"/g' ~/.cinnamon/configs/transparent-panels@germanfr/transparent-panels@germanfr.json
  sed -i -n -f transparent-panel.sed ~/.cinnamon/configs/transparent-panels@germanfr/transparent-panels@germanfr.json
}

function panel() {
  # move panel to the top
  gsettings set org.cinnamon panels-enabled "['1:0:top']"
  gsettings set org.cinnamon panels-autohide "['1:false']"
  gsettings set org.cinnamon panel-edit-mode true
  gsettings set org.cinnamon enabled-applets "['panel1:right:0:systray@cinnamon.org:3', 'panel1:right:1:xapp-status@cinnamon.org:4', 'panel1:right:2:notifications@cinnamon.org:5', 'panel1:right:3:printers@cinnamon.org:6', 'panel1:right:4:removable-drives@cinnamon.org:7', 'panel1:right:5:keyboard@cinnamon.org:8', 'panel1:right:6:favorites@cinnamon.org:9', 'panel1:right:7:network@cinnamon.org:10', 'panel1:right:8:sound@cinnamon.org:11', 'panel1:right:9:power@cinnamon.org:12', 'panel1:right:10:calendar@cinnamon.org:13']"
  gsettings set org.cinnamon panel-edit-mode false
  install_cinnamenu
  install_weather
  gsettings set org.cinnamon enabled-applets "['panel1:right:4:systray@cinnamon.org:3', 'panel1:right:5:xapp-status@cinnamon.org:4', 'panel1:right:6:notifications@cinnamon.org:5', 'panel1:right:7:printers@cinnamon.org:6', 'panel1:right:8:removable-drives@cinnamon.org:7', 'panel1:right:9:keyboard@cinnamon.org:8', 'panel1:right:10:favorites@cinnamon.org:9', 'panel1:right:11:network@cinnamon.org:10', 'panel1:right:12:sound@cinnamon.org:11', 'panel1:right:13:power@cinnamon.org:12', 'panel1:right:14:calendar@cinnamon.org:', 'panel1:left:0:Cinnamenu@json:', 'panel1:right:3:weather@mockturtl:', 'panel1:right:2:scale@cinnamon.org:', 'panel1:right:1:expo@cinnamon.org:', 'panel1:right:15:user@cinnamon.org:']"
  sed -i -n -f transparent-panel.sed ~/.cinnamon/configs/Cinnamenu@json/*.json
  sed -i -n -f transparent-panel.sed /home/dhrumeen/.cinnamon/configs/calendar@cinnamon.org/13.json
}

function install_weather() {
  # Install weather
  wget https://cinnamon-spices.linuxmint.com/files/applets/weather@mockturtl.zip
  unzip weather@mockturtl.zip -d ~/.local/share/cinnamon/applets/
}

function install_cinnamenu() {
  # install Cinnamenu
  wget https://cinnamon-spices.linuxmint.com/files/applets/Cinnamenu@json.zip
  sudo apt-get install unzip
  unzip Cinnamenu@json.zip -d ~/.local/share/cinnamon/applets
}

function install_plank() {
  # Install plank
  sudo apt install plank -y
  echo -e "[Desktop Entry]\nType=Application\nExec=plank\nHidden=false\nNoDisplay=false\nX-GNOME-Autostart-enabled=true\nName=Plank" >> ~/.config/autostart/plank.desktop
  git clone https://github.com/Macintosh98/MacOS-Mojave-Plank-themes PlankMcTheme
  mv PlankMcTheme/themes/* ~/.local/share/plank/themes/
  gsettings set net.launchpad.plank.dock.settings:/net/launchpad/plank/docks/dock1/ theme 'MacOS-BigSur-Light'
  gsettings set net.launchpad.plank.dock.settings:/net/launchpad/plank/docks/dock1/ zoom-enabled true
  gsettings set net.launchpad.plank.dock.settings:/net/launchpad/plank/docks/dock1/ zoom-percent 160
  gsettings set net.launchpad.plank.dock.settings:/net/launchpad/plank/docks/dock1/ dock-items "['xed.dockitem', 'firefox.dockitem', 'org.gnome.Terminal.dockitem', 'trash.dockitem', 'desktop.dockitem']"
}

function mac_setup() {
  buttons
  alt_tab
  transparent_panels
  install_mc_os_theme
  gsettings set org.cinnamon.desktop.wm.preferences theme 'McOS-Cinnamon-Edition'
}

function login_screen() {
  # sudo apt install lightdm-gtk-greeter
  #   
}

function terminal_setup_zsh() {
  # Install zsh and setup
  # get uuid of profiles
  # gsettings get org.gnome.Terminal.ProfilesList list
  # get default profile list
  default_profile_uid=$(gsettings get org.gnome.Terminal.ProfilesList default)
  default_profile_uid=$(echo default_profile_uid | sed s/"'"//g)
  gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:${default_profile_uid}/ use-theme-colors false
  gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:${default_profile_uid}/ background-color 'rgb(0,0,0)'
  gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:${default_profile_uid}/ foreground-color 'rgb(0,255,0)'
  gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:${default_profile_uid}/ use-theme-transparency false
  gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:${default_profile_uid}/ use-transparent-background true
  gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:${default_profile_uid}/ background-transparency-percent 10
  wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf
  wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf
  wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf
  wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf
  mv MesloLGS* ~/.local/share/fonts/
  sudo apt install zsh zsh-syntax-highlighting autojump zsh-autosuggestions -y
  touch "$HOME/.cache/zshhistory"
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  echo 'source ~/powerlevel10k/powerlevel10k.zsh-theme' >> ~/.zshrc
}

function main() {
    install_git
    install_browser
    install_grub
    install_text_editor
    install_vscode
    install_icon_theme
    enable_numlock_on_bootup

    set_dual_boot_timezone
}

main
