echo "Hola desde version.sh."
#set | grep plist

infoPlistPath="$SRCROOT/ikasega/Info.plist"
rootPlistPath="$SRCROOT/Settings.bundle/Root.plist"
#echo "using plist at $infoPlistPath"
#echo "using root at $rootPlistPath"

CFBundleShortVersionString=`/usr/libexec/PlistBuddy -c "Print :CFBundleShortVersionString" $infoPlistPath`
CFBundleVersion=`/usr/libexec/PlistBuddy -c "Print :CFBundleVersion" $SRCROOT/ikasega/Info.plist`

versionString="$CFBundleShortVersionString ($CFBundleVersion)"
versionItemIndex=0

/usr/libexec/PlistBuddy -c "Set :PreferenceSpecifiers:$versionItemIndex:DefaultValue '$versionString'" $rootPlistPath