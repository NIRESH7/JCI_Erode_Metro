#!/bin/bash

# Compile the svg files to vectors
dart run vector_graphics_compiler --input-dir=assets/images/svg --out-dir=assets/images/vectors

# Define the path to the image_constants.dart file
IMAGE_CONSTANTS_FILE="lib/utils/constants/image_constants.dart"

# Initialize the content for the new image_constants.dart file
echo "class AppIcons {" >$IMAGE_CONSTANTS_FILE
echo "  // SVG Vectors" >>$IMAGE_CONSTANTS_FILE

# Append all .vec files to the AppIcons class
for file in assets/images/vectors/*icon* assets/images/jpg/*icon*; do
	filename=$(basename -- "$file")
	classname=$(echo "$filename" | sed -e 's/\.[a-zA-Z0-9]*$//' \
		-e 's/svg//g' \
		-e 's/image//g' \
		-e 's/[^a-zA-Z0-9]/ /g' | awk '{for(i=1;i<=NF;i++) {if(i==1) $i=tolower(substr($i,1,1)) substr($i,2); else $i=toupper(substr($i,1,1)) tolower(substr($i,2))}}1' | tr -d ' ')
	if [[ "$file" == assets/images/vectors/* ]]; then
		echo "  static const String ${classname} = 'assets/images/vectors/${filename}';" >>$IMAGE_CONSTANTS_FILE
	else
		echo "  static const String ${classname} = 'assets/images/jpg/${filename}';" >>$IMAGE_CONSTANTS_FILE
	fi
done

echo "}" >>$IMAGE_CONSTANTS_FILE
echo "" >>$IMAGE_CONSTANTS_FILE
echo "class Images {" >>$IMAGE_CONSTANTS_FILE
echo "  // Image files" >>$IMAGE_CONSTANTS_FILE

# Append all image files to the Images class
for file in assets/images/vectors/*image* assets/images/jpg/*image*; do
	filename=$(basename -- "$file")
	classname=$(echo "$filename" | sed -e 's/\.[a-zA-Z0-9]*$//' \
		-e 's/svg//g' \
		-e 's/image//g' \
		-e 's/[^a-zA-Z0-9]/ /g' | awk '{for(i=1;i<=NF;i++) {if(i==1) $i=tolower(substr($i,1,1)) substr($i,2); else $i=toupper(substr($i,1,1)) tolower(substr($i,2))}}1' | tr -d ' ')
	if [[ "$file" == assets/images/vectors/* ]]; then
		echo "  static const String ${classname} = 'assets/images/vectors/${filename}';" >>$IMAGE_CONSTANTS_FILE
	else
		echo "  static const String ${classname} = 'assets/images/jpg/${filename}';" >>$IMAGE_CONSTANTS_FILE
	fi
done

echo "}" >>$IMAGE_CONSTANTS_FILE
