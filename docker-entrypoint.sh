#!/bin/bash
set -e

# Create .secrets.toml from sample if it doesn't exist
if [ ! -f /home/akmi/mts/conf/.secrets.toml ]; then
  echo "Creating .secrets.toml from .secrets.toml.sample"
  cp /home/akmi/mts/conf/.secrets.toml.sample /home/akmi/mts/conf/.secrets.toml
fi

# Start the application
python -m src.main

