#!/bin/bash

# Step 1: Download glualint
echo "Step 1: Downloading glualint..."
curl -L -o glualint.zip https://github.com/FPtje/GLuaFixer/releases/download/1.26.0/glualint-1.26.0-x86_64-linux.zip
unzip glualint.zip -d glualint

# Step 2: Delete the zip file
echo "Step 2: Deleting glualint.zip..."
rm glualint.zip

# Step 3: Move glualint executable to the root directory
echo "Step 3: Moving glualint executable to the root directory..."
mv glualint/glualint .

# Step 4: Run glualint pretty-print
echo "Step 4: Running glualint pretty-print..."
chmod +x glualint
./glualint --pretty-print

# Step 5: Remove the glualint folder
echo "Step 5: Removing the glualint folder..."
rm -r glualint

echo "Script completed."
