#!/bin/bash

echo "Setting up Lua..."
sudo apt update && sudo apt install -y lua5.2 luarocks liblua5.2-dev

echo "Cloning and building gluacheck..."
git clone https://github.com/impulsh/gluacheck.git gluacheck &&
cd gluacheck &&
sudo luarocks make &&
echo "Running gluacheck..."
cd "/workspaces/Lilia-Experimental/lilia" && sudo chmod +x luacheck && sudo luacheck . --no-redefined \
   --no-global --no-self -i 4.2/.*_ --formatter visual_studio \
  --no-max-line-length --no-max-code-line-length \
  --no-max-string-line-length --no-max-comment-line-length \
  --no-max-cyclomatic-complexity && cd ..

echo "Cleaning up..."
cd "/workspaces/Lilia-Experimental/development"
sudo rm -rf gluacheck

echo "Script completed successfully!"
