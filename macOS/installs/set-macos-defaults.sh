#/usr/bin/env bash

# See https://github.com/SixArm/macos-defaults/blob/main/macos-defaults
# NOTE: Restarting the computer is required for most of these changes to take effect

defaults write com.apple.SoftwareUpdate AutomaticCheckEnabled -bool true
defaults write com.apple.SoftwareUpdate ScheduleFrequency -int 1 # check for updates daily
defaults write com.apple.SoftwareUpdate CriticalUpdateInstall -int 1

defaults write NSGlobalDomain AppleShowAllExtensions -bool true
defaults write NSGlobalDomain com.apple.swipescrolldirection -bool false # disable natural scrolling for mouse scroll wheel
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false # enable key repeat instead of accent menu
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 25

defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -int 0
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true

defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf" # search current folder by default
defaults write com.apple.finder FXPreferredViewStyle Nlsv # use list view by default
defaults write com.apple.finder ShowPathbar -bool true

defaults write com.apple.universalaccess reduceMotion -bool true

defaults write com.apple.dock "orientation" -string "left"
defaults write com.apple.dock show-process-indicators -bool true

defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 0

mkdir -p $HOME/Pictures/Screenshots && defaults write com.apple.screencapture location "~/Pictures/Screenshots"
defaults write com.apple.screencapture show-thumbnail -bool true

for app in Safari Finder Dock Mail SystemUIServer; do killall "$app" >/dev/null 2>&1; done
