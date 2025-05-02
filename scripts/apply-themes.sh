#!/usr/bin/env bash
echo "Starting theme and component installation..."

cd /var/www/discourse

# Popular Discourse themes
THEME_REPOS=(
  "https://github.com/bmc-core/discourse-theme"
)

# Popular Discourse components
COMPONENT_REPOS=(
  "https://github.com/bmc-core/discourse-custom-header-links-icons-component"
  "https://github.com/bmc-core/discourse-breadcrumb-links-component"
  "https://github.com/bmc-core/discourse-character-count-component"
  "https://github.com/bmc-core/discourse-right-sidebar-blocks-component"
  "https://github.com/bmc-core/discourse-new-topic-header-button-component"
  "https://github.com/bmc-core/discourse-gifs-component"
)

# Install themes
for repo in "${THEME_REPOS[@]}"; do
  echo "Installing theme from: $repo"
  su discourse -c "bundle exec rake themes:install_from_git['$repo']"
done

# Install components
for repo in "${COMPONENT_REPOS[@]}"; do
  echo "Installing component from: $repo"
  su discourse -c "bundle exec rake themes:install_from_git['$repo', 'component']"
done

# Set default theme (get the ID of your preferred theme)
su discourse -c "bundle exec rails r '
  theme_id = Theme.where(name: \"BMCCore\").pluck(:id).first
  if theme_id
    SiteSetting.default_theme_id = theme_id
    puts \"Set default theme to BMCCore (ID: #{theme_id})\"
  else
    puts \"Could not find BMCCore theme\"
  end
'"

echo "Theme and component installation completed!"
