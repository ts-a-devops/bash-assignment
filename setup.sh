#!/bin/bash

echo "Setting up project..."

# Update system
sudo apt update -y

# Install dependencies
sudo apt install -y nodejs npm git

# Install PM2 globally
npm install -g pm2

echo "Setup complete!"
