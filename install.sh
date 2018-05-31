#!/bin/sh

# Color Variables
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

# Ask for the administrator password upfront.
sudo -v

function checkMackup {
	if [ -f "$HOME/.mackup.cfg" ] ; then
    echo "No path specified for your app preference backup."
    echo "You can create such a backup via mackup."
    echo -e "${RED}Do you still want to proceed? ${NC}[y/N]"
    read -n 1 -r
    echo    # (optional) move to a new line
    if ! [[ $REPLY =~ ^[Yy]$ ]] ; then
      exit 0
    fi
  fi
}

function setComputerSettings {
	echo -e "${RED}Enter your computer name please?${NC}"
  read cpname
  echo -e "${RED}Please enter your name?${NC}"
  read name
  echo -e "${RED}Please enter your git email?${NC}"
  read email

  clear

  sudo scutil --set ComputerName "$cpname"
  sudo scutil --set HostName "$cpname"
  sudo scutil --set LocalHostName "$cpname"
  defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName -string "$cpname"

  defaults write -g ApplePressAndHoldEnabled -bool false
  defaults write com.apple.finder ShowPathbar -bool true
  defaults write com.apple.finder ShowStatusBar -bool false
  defaults write NSGlobalDomain KeyRepeat -int 0.02
  defaults write NSGlobalDomain InitialKeyRepeat -int 12
  chflags nohidden "$HOME/Library"

  git config --global user.name "$name"
  git config --global user.email "$email"
  git config --global color.ui true
}

function setTrackpadPreferences {
	 # Trackpad: enable tap to click for this user and for the login screen
  defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
  defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
  defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

  # Trackpad: map bottom right corner to right-click
  defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadCornerSecondaryClick -int 2
  defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadRightClick -bool true
  defaults -currentHost write NSGlobalDomain com.apple.trackpad.trackpadCornerClickBehavior -int 1
  defaults -currentHost write NSGlobalDomain com.apple.trackpad.enableSecondaryClick -bool true

  # Disable “natural” (Lion-style) scrolling
  defaults write NSGlobalDomain com.apple.swipescrolldirection -bool false
}

function setLanguagePreferences {
  # Set language and text formats
  defaults write NSGlobalDomain AppleLanguages -array "de"
  defaults write NSGlobalDomain AppleLocale -string "de_DE@currency=EUR"
  defaults write NSGlobalDomain AppleMeasurementUnits -string "Centimeters"
  defaults write NSGlobalDomain AppleMetricUnits -bool true

  # Set the timezone; see `sudo systemsetup -listtimezones` for other values
  sudo systemsetup -settimezone "Europe/Berlin" > /dev/null
}

function setTypingPreferences {
	 # Disable automatic capitalization as it’s annoying when typing code
  defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false

  # Disable smart dashes as they’re annoying when typing code
  defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false

  # Disable automatic period substitution as it’s annoying when typing code
  defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false

  # Disable smart quotes as they’re annoying when typing code
  defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false

  # Disable auto-correct
  defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false
}

function setScreenshotPreferences {
	# Save screenshots to the desktop
  defaults write com.apple.screencapture location -string "${HOME}/Desktop"

  # Save screenshots in PNG format (other options: BMP, GIF, JPG, PDF, TIFF)
  defaults write com.apple.screencapture type -string "png"

  # Disable shadow in screenshots
  defaults write com.apple.screencapture disable-shadow -bool true
}

function setSystemDefaults {
	# Disable the sound effects on boot
  sudo nvram SystemAudioVolume=" "
  
  # Save to disk (not to iCloud) by default
  defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false
  
  # Disable the “Are you sure you want to open this application?” dialog
  defaults write com.apple.LaunchServices LSQuarantine -bool false
  
  # Require password immediately after sleep or screen saver begins
  defaults write com.apple.screensaver askForPassword -int 1
  defaults write com.apple.screensaver askForPasswordDelay -int 0

  # Avoid creating .DS_Store files on network or USB volumes
  defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
  defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

  # Disable disk image verification
  defaults write com.apple.frameworks.diskimages skip-verify -bool true
  defaults write com.apple.frameworks.diskimages skip-verify-locked -bool true
  defaults write com.apple.frameworks.diskimages skip-verify-remote -bool true
}

function setFinderDefaults {
	 # When performing a search, search the current folder by default
  defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

  # Automatically open a new Finder window when a volume is mounted
  defaults write com.apple.frameworks.diskimages auto-open-ro-root -bool true
  defaults write com.apple.frameworks.diskimages auto-open-rw-root -bool true
  defaults write com.apple.finder OpenWindowForNewRemovableDisk -bool true

  # Use column list view in all Finder windows by default
  defaults write com.apple.finder FXPreferredViewStyle -string "clmv"
}

function setDockPreferences {
	 #Set dock icon size to 50 pixels
  defaults write com.apple.dock tilesize -int 50

  # Show indicator lights for open applications in the Dock
  defaults write com.apple.dock show-process-indicators -bool true
}

function setDesktopPreferences {
	# Enable snap-to-grid for icons on the desktop and in other icon views
  /usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:arrangeBy grid" "$HOME/Library/Preferences/com.apple.finder.plist"
  /usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:arrangeBy grid" "$HOME/Library/Preferences/com.apple.finder.plist"
  /usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:arrangeBy grid" "$HOME/Library/Preferences/com.apple.finder.plist"

  # Disable Dashboard
  defaults write com.apple.dashboard mcx-disabled -bool true

  # Don’t show Dashboard as a Space
  defaults write com.apple.dock dashboard-in-overlay -bool true

  # Top right screen corner → Desktop
  defaults write com.apple.dock wvous-tr-corner -int 4
  defaults write com.apple.dock wvous-tr-modifier -int 0
}

function setMenubarPreferences {
	defaults write com.apple.systemuiserver menuExtras '(
  "/System/Library/CoreServices/Menu Extras/Clock.menu",
  "/System/Library/CoreServices/Menu Extras/Battery.menu",
  "/System/Library/CoreServices/Menu Extras/AirPort.menu",
  "/System/Library/CoreServices/Menu Extras/Volume.menu"
  )'

  # Show battery percentage in menu bar
  defaults write com.apple.systemuiserver "NSStatusItem Visible com.apple.menuextra.battery" -bool true
  defaults write com.apple.menuextra.battery '{ ShowPercent = YES; }'
}

function setNightShiftPreferences {
	#enable night shift from 22-07
  CORE_BRIGHTNESS="/var/root/Library/Preferences/com.apple.CoreBrightness.plist"

  ENABLE='{
    CBBlueReductionStatus =     {
      AutoBlueReductionEnabled = 1;
      BlueLightReductionDisableScheduleAlertCounter = 3;
      BlueLightReductionSchedule =         {
        DayStartHour = 7;
        DayStartMinute = 0;
        NightStartHour = 22;
        NightStartMinute = 0;
      };
      BlueReductionEnabled = 0;
      BlueReductionMode = 1;
      BlueReductionSunScheduleAllowed = 1;
      Version = 1;
    };
  }'

  sudo defaults write $CORE_BRIGHTNESS "CBUser-0" "$ENABLE"
  sudo defaults write $CORE_BRIGHTNESS "CBUser-$(dscl . -read "$HOME" GeneratedUID | sed 's/GeneratedUID: //')" "$ENABLE"
}

function setSystemPreferences {
  echo "Setting some preferences..."
 
 	setSystemDefaults
  setTypingPreferences
 	setTrackpadPreferences
 	setLanguagePreferences
 	setScreenshotPreferences
 	setFinderDefaults
 	setDockPreferences
 	setMenubarPreferences
 	setNightShiftPreferences
}

function setSafariPreferences {
  # Privacy: don’t send search queries to Apple
  defaults write com.apple.Safari UniversalSearchEnabled -bool false
  defaults write com.apple.Safari SuppressSearchSuggestions -bool true

  # Set Safari’s home page to `about:blank` for faster loading
  defaults write com.apple.Safari HomePage -string "about:blank"

  # Prevent Safari from opening ‘safe’ files automatically after downloading
  defaults write com.apple.Safari AutoOpenSafeDownloads -bool false

  # Hide Safari’s bookmarks bar by default
  defaults write com.apple.Safari ShowFavoritesBar -bool false

  # Hide Safari’s sidebar in Top Sites
  defaults write com.apple.Safari ShowSidebarInTopSites -bool false

  # Disable Safari’s thumbnail cache for History and Top Sites
  defaults write com.apple.Safari DebugSnapshotsUpdatePolicy -int 2

  # Enable Safari’s debug menu
  defaults write com.apple.Safari IncludeInternalDebugMenu -bool true

  # Make Safari’s search banners default to Contains instead of Starts With
  defaults write com.apple.Safari FindOnPageMatchesWordStartsOnly -bool false

  # Enable the Develop menu and the Web Inspector in Safari
  defaults write com.apple.Safari IncludeDevelopMenu -bool true
  defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true
  defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled -bool true

  # Add a context menu item for showing the Web Inspector in web views
  defaults write NSGlobalDomain WebKitDeveloperExtras -bool true

  # Enable continuous spellchecking
  defaults write com.apple.Safari WebContinuousSpellCheckingEnabled -bool true
  # Disable auto-correct
  defaults write com.apple.Safari WebAutomaticSpellingCorrectionEnabled -bool false

  # Warn about fraudulent websites
  defaults write com.apple.Safari WarnAboutFraudulentWebsites -bool true

  # Block pop-up windows
  defaults write com.apple.Safari WebKitJavaScriptCanOpenWindowsAutomatically -bool false
  defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2JavaScriptCanOpenWindowsAutomatically -bool false

  # Enable “Do Not Track”
  defaults write com.apple.Safari SendDoNotTrackHTTPHeader -bool true

  # Update extensions automatically
  defaults write com.apple.Safari InstallExtensionUpdatesAutomatically -bool true
}

function setMailPreferences {
	# Copy email addresses as `foo@example.com` instead of `Foo Bar <foo@example.com>` in Mail.app
  defaults write com.apple.mail AddressesIncludeNameOnPasteboard -bool false

  # Disable inline attachments (just show the icons)
  defaults write com.apple.mail DisableInlineAttachmentViewing -bool true

  # Disable automatic spell checking
  defaults write com.apple.mail SpellCheckingBehavior -string "NoSpellCheckingEnabled"
}

function setTerminalPreferences {
	# Only use UTF-8 in Terminal.app
  defaults write com.apple.terminal StringEncodings -array 4

  # Enable Secure Keyboard Entry in Terminal.app
  defaults write com.apple.terminal SecureKeyboardEntry -bool true

  # Disable the annoying line marks
  defaults write com.apple.Terminal ShowLineMarks -int 0
}

function setMacAppStorePreferences {
	# Enable the automatic update check
  defaults write com.apple.SoftwareUpdate AutomaticCheckEnabled -bool true

  # Check for software updates daily, not just once per week
  defaults write com.apple.SoftwareUpdate ScheduleFrequency -int 1

  # Download newly available updates in background
  defaults write com.apple.SoftwareUpdate AutomaticDownload -int 1

  # Install System data files & security updates
  defaults write com.apple.SoftwareUpdate CriticalUpdateInstall -int 1

  # Turn on app auto-update
  defaults write com.apple.commerce AutoUpdate -bool true

  # Allow the App Store to reboot machine on macOS updates
  defaults write com.apple.commerce AutoUpdateRestartRequired -bool true
}

function setPhotoPreferences {
	# Prevent Photos from opening automatically when devices are plugged in
  defaults -currentHost write com.apple.ImageCapture disableHotPlug -bool true
}

function setOtherPreferences {
  # Use plain text mode for new TextEdit documents
  defaults write com.apple.TextEdit RichText -int 0

  # Auto-play videos when opened with QuickTime Player
  defaults write com.apple.QuickTimePlayerX MGPlayMovieOnOpen -bool true
}

function killallApplicationsForPreferences {
	for app in "cfprefsd" \
  "Dock" \
  "Finder" \
  "Mail" \
  "Photos" \
  "Safari" \
  "SystemUIServer" \
  "Terminal"; do
    killall "${app}" &> /dev/null
  done
}

function installHomebrew {
	# Install Homebrew
  echo "Installing Homebrew"
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
}

function installJSEnvironment {
	clear
  echo -e "${RED}Setup Javascript Development? ${NC}[y/N]"
  read -n 1 -r
  echo    # (optional) move to a new line
  if [[ $REPLY =~ ^[Yy]$ ]]
    then
    # Install NVM
    echo "Installing NVM"
    curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.31.4/install.sh | bash

    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm so we dont have to reboot the terminal

    #Installing Nodejs
    echo "Installing Nodejs"
    nvm install node
    nvm use node

    #Intalling yarn
    echo "Installing yarn"
    brew install yarn

    #Installing watchman
    echo "Installing watchman"
    brew install watchman

    #Installing react-native-cli
    echo "Installing React-Native CLI"
    npm install -g react-native-cli
  fi
}

function installPythonEnvironment {
	clear
  echo -e "${RED}Install Python? ${NC}[y/N]"
  read -n 1 -r
  echo    # (optional) move to a new line
  if [[ $REPLY =~ ^[Yy]$ ]]
    then
    # Install Python
    brew install python
  fi
}

function installRubyEnvironment {
	clear
  echo -e "${RED}Install Ruby?${NC} [y/N]"
  read -n 1 -r
  echo    # (optional) move to a new line
  if [[ $REPLY =~ ^[Yy]$ ]]
    then
    # Install ruby with rvm and bundler
    brew install gpg
    command curl -sSL https://rvm.io/mpapis.asc | gpg --import -
    \curl -L https://get.rvm.io | bash -s stable
    source ~/.rvm/scripts/rvm
    rvm install ruby-2.3.1

    gem install bundler
  fi
}

function installiOSEnvironment {
  clear
  echo -e "${RED}Setup iOS Development?${NC} [y/N]"
  read -n 1 -r
  echo    # (optional) move to a new line
  if [[ $REPLY =~ ^[Yy]$ ]]
    then
    echo -e "Installing\n[+]cocoapods\n[+]carthage\n[+]fastlane\n[+]opensim\n[+]marathon\n[+]testdrive"
    sudo gem install cocoapods
    
    brew install \
    carthage \
    marathon-swift

    marathon install johnsundell/testdrive

    brew cask install \
    fastlane \
    opensim
  fi
}

function installJavaEnvironment {
	clear
  echo -e "${RED}Setup for Java Development? ${NC}[y/N]"
  read -n 1 -r
  echo    # (optional) move to a new line
  if [[ $REPLY =~ ^[Yy]$ ]]
    then
    echo "Installing\n[+]Java\n[+]Eclipse"
    brew cask install \
    java \
    eclipse-ide \
    eclipse-java
  fi
}

function installAndroidEnvironment {
	clear
  echo -e "${RED}Setup For Android Development?${NC} [y/N]"
  read -n 1 -r
  echo    # (optional) move to a new line
  if [[ $REPLY =~ ^[Yy]$ ]]
    then
    echo -e "Installing\n[+]Java\n[+]Eclipse\n[+]Android-Studio\n[+]IntelliJ IDEA Community Edition\n[+]gradle\n[+]Android-SDK"
    brew cask install \
    java \
    eclipse-ide \
    eclipse-java \
    android-studio \
    intellij-idea-ce

    brew install gradle
    brew install android-sdk
  fi
}

function installDatabases {
	clear
  echo -e "${RED}Install Databases? ${NC}[y/N]"
  read -n 1 -r
  echo    # (optional) move to a new line
  if [[ $REPLY =~ ^[Yy]$ ]]
    then
    echo -e "Installing\n[+]MySQL\n[+]PostgreSQL\n[+]Mongo\n[+]DBeaver"
    brew install mysql
    brew install postgresql
    brew install mongo

    # Install DBeaver
    # Install Cask
    brew install caskroom/cask/brew-cask
    brew cask install --appdir="/Applications" dbeaver-community
  fi
}

function installCommandLineTools {
	clear
  # Install Homebrew Apps
  echo "Installing Homebrew Command Line Tools"
  echo -e "Installing\n[+]wget\n[+]micro\n[+]jid\n[+]vim\n[+]tldr\n[+]z\n[+]ag\n[+]oh-my-zsh"
  brew install \
  wget \
  micro \
  jid \
  vim \
  tldr \
  z \
  the_silver_searcher

  sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
}

function tapCask {
  brew tap caskroom/cask
  brew tap caskroom/versions
}

function installOptionalApplications {
	clear
  echo -e "${RED}Install Kitematic? ${NC}[y/N]"
  read -n 1 -r
  echo    # (optional) move to a new line
  if [[ $REPLY =~ ^[Yy]$ ]]
    then
    # Install Kitematic
    brew cask install kitematic
  fi

  clear
  echo -e "${RED}Install Franz? ${NC}[y/N]"
  read -n 1 -r
  echo    # (optional) move to a new line
  if [[ $REPLY =~ ^[Yy]$ ]]
    then
    # Install Franz
    brew cask install franz
  fi

  clear
  echo -e "${RED}Install HexFiend? ${NC}[y/N]"
  read -n 1 -r
  echo    # (optional) move to a new line
  if [[ $REPLY =~ ^[Yy]$ ]]
    then
    # Install HexFiend
    brew cask install hex-fiend
  fi

  clear
  echo -e "${RED}Install Iina? ${NC}[y/N]"
  read -n 1 -r
  echo    # (optional) move to a new line
  if [[ $REPLY =~ ^[Yy]$ ]]
    then
    # Install Iina
    brew cask install iina
  fi

  clear
  echo -e "${RED}Install Fritzing? ${NC}[y/N]"
  read -n 1 -r
  echo    # (optional) move to a new line
  if [[ $REPLY =~ ^[Yy]$ ]]
    then
    # Install Fritzing
    brew cask install fritzing
  fi

  clear
  echo -e "${RED}Install Resign? ${NC}[y/N]"
  read -n 1 -r
  echo    # (optional) move to a new line
  if [[ $REPLY =~ ^[Yy]$ ]]
    then
    # Install Resign
    git clone https://github.com/LigeiaRowena/Resign.git "Resign"
    mv "./Resign/Resign.app" "/Applications/"
    rm -Rf "Resign"
  fi

  clear
  echo -e "${RED}Install Virtualbox? ${NC}[y/N]"
  read -n 1 -r
  echo    # (optional) move to a new line
  if [[ $REPLY =~ ^[Yy]$ ]]
    then
    # Install Virtualbox
    brew cask install virtualbox
    brew cask install virtualbox-extension-pack
  fi

  clear
  echo -e "${RED}Install Sketch? ${NC}[y/N]"
  read -n 1 -r
  echo    # (optional) move to a new line
  if [[ $REPLY =~ ^[Yy]$ ]]
    then
    # Install Sketch
    brew cask install sketch
  fi

  clear
  echo -e "${RED}Install MacTeX & TeXMaker? ${NC}[y/N]"
  read -n 1 -r
  echo    # (optional) move to a new line
  if [[ $REPLY =~ ^[Yy]$ ]]
    then
    # Install Tex Tools and Editor
    brew cask install mactex
    brew cask install texmaker
  fi
}

function installMacAppStoreApps {
  echo -e "${RED}Install some of your Mac App Store Apps? ${NC}[y/N]"
  read -n 1 -r
  echo    # (optional) move to a new line
  if [[ $REPLY =~ ^[Yy]$ ]]
    then
    #Install mas
    brew install mas
    echo -e "Provide your Mac App Store email address"
    read masEmail
    echo # (optional) move to a new line
    mas signin "$masEmail"
    echo "Listing available Mac App Store apps: "
    echo # (optional) move to a new line
    mas list
    echo # (optional) move to a new line
    echo "Provide a comma separated list of ids of applications to install: "
    read applicationIds
    applicationIdsWithoutWhitespace=$(echo $applicationIds | tr -d ' ')
    ids=$(echo $applicationIdsWithoutWhitespace | tr "," "\n")
    for id in $ids
    do
      mas install "$id"
    done
  fi
}

function installApplications {
	echo "Installing Apps"
  echo -e "Installing\n[+]Google Chrome\n[+]Reggy\n[+]AppCleaner\n[+]Sublime Text\n[+]Dropbox\n[+]Tower Git\n[+]Charles Web Proxy\n[+]Dash\n[+]Hopper Disassembler & Debugger Server\n[+]Alfred 3\n[+]1Password\n[+]Visual Studio Code\n[+]Fantastical 2\n[+]Evernote\n[+]AppCode\n[+]Spotify\n[+]TeaCode"

  brew cask install \
  google-chrome \
  paw \
  reggy \
  appcleaner \
  dropbox \
  tower \
  charles \
  dash \
  hopper-disassembler \
  hopper-debugger-server \
  alfred \
  1password \
  visual-studio-code \
  sublime-text \
  fantastical \
  evernote \
  appcode \
  spotify \
  bettertouchtool

  curl -o "$HOME/TeaCode.zip" "https://www.apptorium.com/teacode/trial"
  unzip "$HOME/TeaCode.zip"
  mv "$HOME/TeaCode.app" "/Application/"
  rm "$HOME/TeaCode.zip"
}

function restoreMackupBackup {
  if [ -f "$HOME/.mackup.cfg" ] ; then
    echo "${RED}No backup path specified. Skipping this step.${NC}"
  else
    echo "Restoring some App Preferences from mackup"
    git clone https://github.com/dehlen/mackup "$HOME/.mackup-master"
    make -C "$HOME/.mackup-master"
    mackup restore
  fi
}

function installFonts {
	echo "Installing Fonts"
  fonts=(
    font-hack
    font-inconsolata
    font-droid-sans-mono
    font-droid-sans
    font-source-code-pro
    font-source-sans-pro
    font-ubuntu
    font-arvo
    font-baumans
    font-bowlby-one
    font-bree-serif
    font-cabin
    font-cabin-condensed
    font-cabin-sketch
    font-comfortaa
    font-droid-serif
    font-fira-mono
    font-fira-code
    font-fira-sans
    font-lato
    font-lobster
    font-montserrat
    font-offside
    font-open-sans
    font-open-sans-condensed
    font-paytone-one
    font-titan-one
    font-varela
    )
  brew cask install ${fonts[@]}
}

function installBashrc {
	echo "Installing .bashrc"
  echo "
  . /usr/local/etc/profile.d/z.sh

  export EDITOR='sublime'

  alias subl='open -a /Applications/Sublime\ Text.app'
  function h() {
    if [ -z \"\$1\" ]
      then
      history
    else
      history | grep \"\$@\"
    fi
  }

  alias ll='ls -la'

  function find_dir {
		find \"\$PWD\" -type d -name \"\$1\"
	}

	function find_file {
		find \"\$PWD\" -type f -name \"\$1\"
	}

	function sublf() {
  	for i in \$(ag -l --hidden \"\$1\"); do subl \"\$i\"; done
	}
	" >> "$HOME/.bashrc"
}

function installBashProfile {
	echo "Installing .bash_profile"
  echo "
  source ~/.bashrc

  shopt -s histappend;
  PS1='\[\033[1;36m\]\$: \[\033[0;33m\][\w]\[\033[0m\] → '

  export CLICOLOR=1
  export LSCOLORS=ExFxBxDxCxegedabagacad" >> "$HOME/.bash_profile"
}

function installVimConfiguration {
	echo "Installing vim configuration"
  git clone --depth=1 https://github.com/amix/vimrc.git "$HOME/.vim_runtime"
  sh "$HOME/.vim_runtime/install_awesome_vimrc.sh"
  echo "
  set number
  syntax enable
  set background=dark
  colorscheme solarized
  let g:netrw_banner = 0
  set clipboard=unnamed
  " >> "$HOME/.vim_runtime/my_configs.vim"
}

function codesignXcodeAndInstallPlugins {
	echo -e "${RED}CodeSign Xcode to Install Plugins? ${NC}[y/N]"
  read -n 1 -r
  echo    # (optional) move to a new line
  if [[ $REPLY =~ ^[Yy]$ ]]
    then
	  echo "Generating Certificate to codesign Xcode"
	  cert="XcodeSigner"
	  echo "
	  [ req ]
	  default_bits       = 2048        # RSA key size
	  encrypt_key        = no          # Protect private key
	  default_md         = sha512      # MD to use
	  prompt             = no          # Prompt for DN
	  distinguished_name = codesign_dn # DN template
	  [ codesign_dn ]
	  commonName         = "XcodeSigner"
	  [ codesign_reqext ]
	  keyUsage           = critical,digitalSignature
	  extendedKeyUsage   = critical,codeSigning
	  " > "${cert}.cfg"
	  if $(security find-certificate -Z -p -c "$cert" /Library/Keychains/System.keychain 2>&1 | egrep -o '^SHA-1' >/dev/null); then
	    echo "$cert is already installed, no need to create it"
	  else
	    echo "Generating $cert"
	    openssl req -new -newkey rsa:2048 -x509 -days 3650 -nodes -config "${cert}.cfg" -extensions codesign_reqext -batch -out "${cert}.pem" -keyout "${cert}.key"
	    echo "[SUDO] Installing ${cert} as root"
	    sudo security add-trusted-cert -d -r trustRoot -k /Library/Keychains/System.keychain "${cert}.pem"
	    sudo security import "${cert}.key" -A -k /Library/Keychains/System.keychain
	    echo "[SUDO] Killing taskgated"
	    sudo pkill -f /usr/libexec/taskgated
	    rm "${cert}.key"
	    rm "${cert}.pem"
	    rm "${cert}.cfg"
	  fi
	  echo "Signing Xcode with the created certificate"
	  xcodePath="$(xcode-select -p)"
	  xcodePath="${xcodePath%%/Contents*}"
	  sudo codesign -f -s "$cert" "$xcodePath"
  	
  	echo -e "${RED}Install XVim2 Plugin? ${NC}[y/N]"
  	read -n 1 -r
  	echo    # (optional) move to a new line
  	if [[ $REPLY =~ ^[Yy]$ ]]
    	then
	  	echo "Loading XVim Plugin for Xcode"
    	git clone https://github.com/XVimProject/XVim2.git "$HOME/.xcode_plugins"
    	make -C "$HOME/.xcode_plugins"
    	echo "${RED}Plugin successfully installed. Launch Xcode and select \"Load Bundle\".${NC}"
    	echo "${RED}If you clicked \"Don't Load Bundle\" by mistake execute the following from Terminal and launch Xcode again: defaults delete com.apple.dt.Xcode DVTPlugInManagerNonApplePlugIns-Xcode-X.X # (X.X is your Xcode version)${NC}"
  	fi
  fi
}

# Keep Sudo Until Script is finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# Check if OSX Command line tools are installed
if type xcode-select >&- && xpath=$( xcode-select --print-path ) &&
  test -d "${xpath}" && test -x "${xpath}" ; then

  checkMackup
  setComputerSettings
 	setSystemPreferences
 	setSafariPreferences
 	setMailPreferences
 	setTerminalPreferences
 	setPhotoPreferences
 	setOtherPreferences

  echo "${GREEN}Done setting preferences."
  echo "Note that some of these changes require a logout/restart to take effect."

  installHomebrew
  installJSEnvironment
  installPythonEnvironment
  installRubyEnvironment
  installiOSEnvironment
  installJavaEnvironment
  installAndroidEnvironment
  installDatabases
  installCommandLineTools
  installCask
  installOptionalApplications
  installMacAppStoreApps
  installApplications
  restoreMackupBackup
  installFonts
  installBashrc
  installBashProfile
  installVimConfiguration
  codesignXcodeAndInstallPlugins

  echo "Cleaning Up Cask Files"
  brew cask cleanup
  clear
  echo "${GREEN}Done${NC}"

  exit 0
else
  echo "Need to install the OSX Command Line Tools (or XCode) First! Starting Install..."
  echo "Start the script after the OSX Command Line Tools successfully installed once again."
  # Install XCODE Command Line Tools
  xcode-select --install
fi
