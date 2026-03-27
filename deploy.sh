#!/bin/bash

echo "Starting deployment..."

# Pull latest code
git pull origin main

# Install dependencies (example for Node.js)
npm install

# Build project
npm run build

# Restart service (example)
pm2 restart app || pm2 start app.js --name app

echo "Deployment completed!"
