#!/usr/bin/env bash
echo "Starting site settings configuration..."
cd /var/www/discourse
su discourse -c "bundle exec rails r /var/discourse/shared/standalone/scripts/apply-site-settings.rb"
echo "Settings configuration completed!"
