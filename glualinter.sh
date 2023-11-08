#!/bin/bash

# Step 1: Checkout code for glualint
echo "Step 1: Checking out code for glualint..."
mkdir -p glualint
cd glualint
git clone https://github.com/YourUsername/YourRepository.git .
cd ..

# Step 2: Download glualint
echo "Step 2: Downloading glualint..."
curl -L -o glualint.zip https://github.com/FPtje/GLuaFixer/releases/download/1.26.0/glualint-1.26.0-x86_64-linux.zip
unzip glualint.zip -d glualint

# Step 3: Run glualint pretty-print
echo "Step 3: Running glualint pretty-print..."
cd glualint
chmod +x glualint
./glualint --pretty-print	
# Step 4: Delete the zip file
echo "Step 4: Deleting glualint.zip..."
rm ../glualint.zip

echo "Script completed."
