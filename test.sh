

#!/bin/bash

# Define the string to be added at the top of each file
STRING_TO_ADD="------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local MODULE = MODULE"

# Specify the folder path
FOLDER_PATH="/workspaces/Lilia-Experimental/lilia/modularity/"

# Find all files under the specified folder and its subfolders
find "$FOLDER_PATH" -type f -print0 | while IFS= read -r -d '' FILE; do
  # Add the string at the top of each file
  echo "$STRING_TO_ADD" | cat - "$FILE" > temp && mv temp "$FILE"
  echo "Added string to $FILE"
done

echo "Script executed successfully!"
