#!/bin/sh
security delete-keychain ios-build.keychain
rm -f "~/Library/MobileDevice/Provising\ Profiles/$PROFILE_NAME.mobileprovision"
