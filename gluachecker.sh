#!/bin/bash

# Setup Lua
echo "Setting up Lua..."
sudo apt update
sudo apt install -y lua5.2
sudo apt install -y luarocks
sudo apt-get install liblua5.2-dev

# Pull gluacheck
echo "Cloning gluacheck..."
git clone https://github.com/impulsh/gluacheck.git gluacheck

# Build gluacheck
echo "Building gluacheck..."
cd gluacheck
sudo luarocks make
cd ..
cd lilia
ls
# Lint with gluacheck
echo "Running gluacheck..."
sudo luacheck . --no-unused-secondaries --no-unused-args --no-redefined \
  --no-unused --no-global --no-self -i 4.2/.*_ --formatter visual_studio \
  --no-unused --no-max-line-length --no-max-code-line-length \
  --no-max-string-line-length --no-max-comment-line-length \
  --no-max-cyclomatic-complexity

# Clean up
cd ..
echo "Cleaning up..."
sudo rm -rf gluacheck
echo "Script completed successfully!"