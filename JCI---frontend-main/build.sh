#! /bin/sh

# Build the AAB file
flutter clean
flutter pub get
read -rp "Did you updated the version code and version name in pubspec.yaml file? [y/n]" version
if [ "$version" == "y" ]; then
	echo "Building the app..."
	read -rp "What do you want to build 1.APK 2.AppBundle [1/2]" buildType
	if [ "$buildType" == "1" ]; then
		flutter build apk --release
	elif [ "$buildType" == "2" ]; then
		flutter build appbundle --release
	else
		echo "Invalid input"
	fi
else
	echo "Please update the version code and version name in pubspec.yaml file"
	exit 1
fi
