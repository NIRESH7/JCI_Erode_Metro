#! /bin/sh

# Clean the project
flutter clean
flutter pub get
echo "Cleaned the project"

while getopts "abc" opt; do
	case $opt in
	a)
		echo "Building APK"
		flutter build apk
		;;
	b)
		echo "Building App Bundle"
		flutter build appbundle --release --dart-define-from-file=.env.production -PenvFile=.env.production
		;;
	c) ;;
	\?)
		echo "Invalid option: -$OPTARG" >&2
		;;
	esac
done
