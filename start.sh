#!/bin/bash

echo "Starting application..."

pm2 start app.js --name app

echo "Application started!"
