# Configurable constants
TIMEZONE="Asia/Seoul"
AYATANA_DEB="https://raw.githubusercontent.com/Lafydev/wingpanel-indicator-ayatana/master/com.github.lafydev.wingpanel-indicator-ayatana_2.0.7_odin.deb"
NVM_INSTALL_SH="https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh"
OPENJDK_TAR_GZ="https://download.java.net/java/GA/jdk16.0.2/d4a915d82b4c4fbb9bde534da945d746/7/GPL/openjdk-16.0.2_linux-x64_bin.tar.gz"
PYTHON_VERSION="3.9.6"

# Text colors
RED=`tput setaf 1`
GREEN=`tput setaf 2`
YELLOW=`tput setaf 3`
BLUE=`tput setaf 4`
MAGENTA=`tput setaf 5`
CYAN=`tput setaf 6`
BOLD=`tput bold`
RESET=`tput sgr0`

# Enter sudo password in advance
sudo su
exit

# Set the timezone to Asia/Seoul
echo "${BLUE}Set the timezone to Asia/Seoul${RESET}"
timedatectl set-timezone $TIMEZONE

# Update apt
echo "${BLUE}Update apt${RESET}"
sudo apt update

# Install some basic packages
echo "${BLUE}Install some basic packages${RESET}"
sudo apt -y install \
    git curl make build-essential libssl-dev zlib1g-dev libbz2-dev \
    g++ gcc libgmp3-dev libncurses5-dev manpages-fr-extra xz-utils \
    libreadline-dev libsqlite3-dev wget llvm libncurses5-dev libncursesw5-dev \
    xz-utils tk-dev libffi-dev liblzma-dev python-openssl \
    libglib2.0-dev libgranite-dev libindicator3-dev libwingpanel-dev indicator-application

# Add flathub repository
echo "${BLUE}Add flathub repository${RESET}"
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# Install Firefox
echo "${BLUE}Install ${BOLD}Firefox${RESET}"
flatpak install -y flathub org.mozilla.firefox

# Install Wingpanel Ayatana-Compatibility Indicator
echo "${BLUE}Install ${BOLD}Wingpanel Ayatana-Compatibility Indicator${RESET}"
curl $AYATANA_DEB -o com.github.lafydev.wingpanel.deb
sudo dpkg -i com.github.lafydev.wingpanel.deb
rm com.github.lafydev.wingpanel.deb
mkdir -p ~/.config/autostart
cp /etc/xdg/autostart/indicator-application.desktop ~/.config/autostart/
sed -i 's/^OnlyShowIn.*/OnlyShowIn=Unity;GNOME;Pantheon;/' ~/.config/autostart/indicator-application.desktop

# Install ibus
echo "${BLUE}Install ${BOLD}ibus${RESET}"
echo -e "\nexport GTK_IM_MODULE=ibus\nexport XMODIFIERS=@im=ibus\nexport QT_IM_MODULE=ibus\n" >> $HOME/.bashrc
sudo apt -y install ibus ibus-hangul ibus-anthy
im-config -n ibus
echo "${GREEN}${BOLD}$(ibus version)${RESET}${GREEN} is installed. Please set input methods manually using \`ibus-setup'.${RESET}"

# Install Visual Studio Code
echo "${BLUE}Install ${BOLD}Visual Studio Code${RESET}"
flatpak install -y flathub com.visualstudio.code
echo -e "\nalias code=\"/var/lib/flatpak/exports/bin/com.visualstudio.code\"" >> .bashrc
echo "${GREEN}${BOLD}Visual Studio Code $(code --version | head -n 1)${RESET}${GREEN} is installed.${RESET}"

# Install WPS Office
echo "${BLUE}Install ${BOLD}WPS Office${RESET}"
flatpak install -y flathub com.wps.Office
echo "${GREEN}${BOLD}WPS Office $(flatpak list | grep 'WPS Office' | awk '{ print $4 }')${RESET}${GREEN} is installed.${RESET}"

# Install Zoom
echo "${BLUE}Install ${BOLD}Zoom${RESET}"
flatpak install -y flathub us.zoom.Zoom
echo "${GREEN}${BOLD}Zoom $(flatpak list | grep 'Zoom' | awk '{ print $3 }')${RESET}${GREEN} is installed.${RESET}"

# Install Discord
echo "${BLUE}Install ${BOLD}Discord${RESET}"
flatpak install -y flathub com.discordapp.Discord
echo "${GREEN}${BOLD}Discord $(flatpak list | grep 'Discord' | awk '{ print $3 }')${RESET}${GREEN} is installed.${RESET}"

# Install Github CLI
echo "${BLUE}Install ${BOLD}GitHub CLI${RESET}"
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo gpg --dearmor -o /usr/share/keyrings/githubcli-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
sudo apt update
sudo apt install gh
echo "${GREEN}${BOLD}GitHub CLI $(gh --version | head -n 1 | awk '{ print $3 }')${RESET}${GREEN} is installed.${RESET}"

# Install nvm
echo "${BLUE}Install ${BOLD}nvm${RESET}"
curl -o- $NVM_INSTALL_SH | bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
echo "${GREEN}${BOLD}nvm $(nvm --version)${RESET}${GREEN} is installed.${RESET}"

# Install Node.js
echo "${BLUE}Install ${BOLD}Node.js${RESET}"
nvm install node
echo "${GREEN}${BOLD}Node.js $(node --version)${RESET}${GREEN} is installed.${RESET}"

# Update npm
echo "${BLUE}Update ${BOLD}npm${RESET}"
npm install -g npm
echo "${GREEN}${BOLD}npm $(npm --version)${RESET}${GREEN} is installed.${RESET}"

# Install Yarn
echo "${BLUE}Install ${BOLD}Yarn${RESET}"
npm install -g yarn
echo "${GREEN}${BOLD}Yarn $(yarn --version)${RESET}${GREEN} is installed.${RESET}"

# Install OpenJDK 16
echo "${BLUE}Install ${BOLD}OpenJDK 16${RESET}"
curl $OPENJDK_TAR_GZ -o "$HOME/openjdk-16.tar.gz"
sudo tar -zxf "$HOME/openjdk-16.tar.gz" -C /opt
sudo mv /opt/jdk-16* /opt/openjdk-16
sudo update-alternatives --install /usr/bin/java java /opt/openjdk-16/bin/java 100
rm "$HOME/openjdk-16.tar.gz"
echo "${GREEN}${BOLD}OpenJDK $(java -version 2>&1 | head -n 1 | awk -F '"' '{print $2}')${RESET}${GREEN} is installed.${RESET}"

# Install pyenv
echo "${BLUE}Install ${BOLD}pyenv${RESET}"
curl https://pyenv.run | bash
echo -e "\nexport PATH=\"\$HOME/.pyenv/bin:\$HOME/.pyenv/shims:\$PATH\"" >> .bashrc
echo -e "eval \"\$(pyenv init -)\"" >> .bashrc
echo -e "eval \"\$(pyenv virtualenv-init -)\"" >> .bashrc
. ~/.bashrc
echo "${GREEN}${BOLD}$(pyenv --version)${RESET}${GREEN} is installed.${RESET}"

# Install Python 3.9.6
echo "${BLUE}Install ${BOLD}Python $PYTHON_VERSION${RESET}"
pyenv install $PYTHON_VERSION
pyenv global $PYTHON_VERSION
echo "${GREEN}${BOLD}$(python --version)${RESET}${GREEN} is installed.${RESET}"

# Install cargo
echo "${BLUE}Install ${BOLD}cargo${RESET}"
curl https://sh.rustup.rs -sSf | sh -s -- -y
source $HOME/.cargo/env
echo "${GREEN}${BOLD}$(cargo --version)${RESET}${GREEN} is installed.${RESET}"

# Install GHC
echo "${BLUE}Install ${BOLD}GHC${RESET}${BLUE}. Please type ENTER, P, Y, Y, and ENTER consequently.${RESET}"
curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | sh
source $HOME/.ghcup/env
echo "${GREEN}${BOLD}$(cargo --version)${RESET}${GREEN} is installed.${RESET}"

# Install TeX
