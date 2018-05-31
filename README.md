mast is a installation script which contains several installation instructions to setup my basic workspace on new macs. Feel free to fork and adapt it to your needs. This script makes use of multiple other open source projects:

- [DevMyMac](https://github.com/adamisntdead/DevMyMac)
- [mackup](https://github.com/lra/mackup) (using my own fork)
- [dotfiles](https://github.com/mathiasbynens/dotfiles)


## Prerequisites
- Xcode
- Xcode Command Line Tools

## What does the script do ?

**Some mandatory applications, dotfiles and preferences for me are installed automatically.**

- Hostname, Computername
- Git Configuration
- Preferences (System, Dock, Finder)
    - Disable sound effects on startup
    - Save to disk, not iCloud as default
    - Disable "Are you sure you want to open ?" dialog
    - Disable automatic capitalization, smart dashes and auto correct
    - Enable trackpad "tap to click" and secondary click
    - Disable natural scrolling
    - Set timezone to Berlin
    - Require password immediately after sleep
    - Save screenshots to Desktop
    - Save screenshots as .png
    - Search current folder as default in Finder
    - Disable disk image verification
    - Automatically open Finder window when a new volume is mounted
    - Use column view as a default in Finder
    - Set dock icon size to 50px
    - Show indicator lights in dock for open applications
    - Disable Dashboard
    - Show desktop on right screen corner
    - Show clock, battery, airport and volume in menubar
    - Show battery percentage
    - Enable night shift from 22:00 - 07:00
- Preferences (Safari)
    - Don't send queries to Apple
    - Set homepage to about:blank
    - Hide bookmark bar
    - Prevent opening files after downloading
    - Hide sidebar in Top Sites
    - Disable thumbnail cache
    - Enable debug menu
    - Make Safari's search banners default to contains
    - Enable Develop menu
    - Add context menu item to open element in web inspector
    - Enable continuous spellchecking
    - Disable auto correct
    - Warn about fraudulent sites
    - Block pop-up windows
    - Enable "Do not track"
    - Update extensions automatically
- Preferences (Mail)
    - Copy email addresses like foo@bar.com
    - Disable inline attachments
    - Disable automatic spellchecking
- Preferences (Terminal)
    - Use UTF-8
    - Enable secure keyboard entry
    - Disable line marks
- Preferences (Mac App Store)
    - Enable automatic updates
    - Check for software updates daily
    - Download new updates in background
    - Install system data files and security updates
    - Allow Mac App Store to reboot the machine
- Preferences (Photos)
    - Prevent Photos from opening when plugging in a device
- Preferences (Other)
    - Use plain text for new TextEdit documents
    - Auto play videos when opened with QuickTime
- Installing homebrew
- Installing homebrew-cask
- Installing command line tools
    - wget
    - micro
    - jid
    - vim
    - tldr
    - z
    - ag
    - oh-my-zsh
- Installing applications
    - google chrome
    - paw
    - reggy
    - appcleaner
    - dropbox
    - tower
    - charles
    - dash
    - hopper disassembler & debugger server
    - alfred 3
    - 1password
    - visual studio code
    - sublime text
    - fantastical
    - evernote
    - appcode
    - spotify
    - teacode
    - bettertouchtool
- Installing fonts
    - anonymous-pro
    - hack
    - inconsolata
    - droid-sans-mono
    - droid-sans
    - source-code-pro
    - source-sans-pro
    - ubuntu
    - arvo
    - baumans
    - bowlby-one
    - bree-serif
    - cabin
    - cabin-condensed
    - cabin-sketch
    - comfortaa
    - droid-serif
    - fira-mono
    - fira-code
    - fira-sans
    - lato
    - lobster
    - montserrat
    - offside
    - open-sans
    - open-sans-condensed
    - paytone-one
    - titan-one
    - varela
- Installing dotfiles
    - bashrc
    	- setting sublime as EDITOR variable
    	- configuring z shell script to change directories more easily
    	- alias for listing all files in a directory, including hidden files
    	- alias for sublime
    	- alias for searching through history
    	- alias for finding files and folders recursively
    	- function to show a notification if a terminal command exits while the terminal window is in background
        - function to search for a specific text and open all files containing that text in sublime
    - bash_profile
    	- configure colors and prefix in terminal window
    - vim configuration
    - zshrc
    - oh-my-zsh theme

**Other applications, dotfiles and preferences are optional and the user is asked on every step to continue installation or not.**

- Installing node.js
    - nvm
    - node
    - npm
    - yarn
    - watchman
    - react-native-cli
- Installing python
- Installing ruby
    - gpg
    - ruby
    - rvm
    - bundler
- Installing tools for iOS Development
    - cocoapods
    - carthage
    - marathon
    - testdrive
    - fastlane
    - opensim
    - swiftlint
- Installing tools Java Development
    - jdk
    - eclipse
- Installing tools for Android Development
    - jdk
    - eclipse
    - android studio
    - intelliJ idea ce
    - gradle
    - android-sdk
- Installing databases & database clients
    - mysql
    - postgresql
    - mongodb
    - dbeaver
- Installing kitematic
- Installing franz
- Installing hexfiend 
- Installing iina
- Installing fritzing
- Installing resign
- Installing virtualbox
- Installing sketch
- Installing mactex & texmaker
- Installing some of your Mac App Store Apps
    - Sign in and choose which ones you'd like to install
- Installing saved backup from mackup

## Mackup
mast makes use of my own fork of [mackup](https://github.com/lra/mackup). The fork contains several merged pull requests for applications I am installing with this script. Mackup syncs various application preferences by copying the respective files to a chosen engine like iCloud or Dropbox and symlinks them on the host computer. This way the preferences will always stay in sync. This repository contains a sample mackup.cfg which I used to backup application preferences. The backuped files may also include licenses so you won't have to reinstall them. For further information on mackup have a look at the linked repository.

Please note that restoring application preferences with mackup is an optional process and can be omitted. The script will look for a valid .mackup.cfg file in the $HOME folder and asks to restore application preferences based on that information. You don't need to have mackup installed on the new machine since the script will checkout my fork of mackup.

## Further Steps
- Setup Developer Account in Xcode
- Copy folders/files from the HOME directory of your old computer if needed
- Open apps like dropbox to login or to add license files which were not synched via mackup

## Naming
If you wondered mast stands for **ma**c **s**etup **t**ool.

## License

Copyright David Ehlen 2017

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
