#!/bin/bash
echo "Starting theme installation process..."

cd /var/www/discourse
su discourse -c "bundle exec rails runner /shared/scripts/apply-themes.rb"

echo "Theme installation process completed!"
