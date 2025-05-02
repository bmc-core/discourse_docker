# install_themes.rb - Script to install Discourse themes and components

puts "Starting theme and component installation..."

# Helper method to install a theme from Git
def install_theme_from_git(repo_url, type = "theme", branch_or_version = nil)
  puts "Installing #{type} from #{repo_url}#{branch_or_version ? " (#{branch_or_version})" : ""}"

  begin
    importer = ThemeStore::GitImporter.new(repo_url, branch: branch_or_version)

    if type == "component"
      theme = RemoteTheme.import_theme(importer, -1)
    else
      theme = Theme.create!(name: File.basename(repo_url, ".git"), user_id: -1)
      theme.set_field(target: :common, name: :scss, value: "")
      theme.set_field(target: :desktop, name: :scss, value: "")
      theme.set_field(target: :mobile, name: :scss, value: "")
      theme.remote_theme = RemoteTheme.create!(
        remote_url: repo_url,
        branch: branch_or_version,
        theme_id: theme.id
      )
      theme.save!
      theme.remote_theme.update_from_remote(importer)
    end

    puts "Successfully installed #{type}: #{theme.name} (ID: #{theme.id})"
    return theme.id
  rescue => e
    puts "Error installing #{type} from #{repo_url}: #{e.message}"
    puts e.backtrace.join("\n")
    return nil
  end
end

# Check if theme already exists
def theme_exists?(repo_url)
  name = File.basename(repo_url, ".git")
  Theme.where("name LIKE ?", "%#{name}%").exists?
end

# Install themes (only if they don't already exist)
theme_ids = []

# List of themes to install
theme_repos = [
  "https://github.com/bmc-core/discourse-theme"
]

theme_repos.each do |repo|
  unless theme_exists?(repo)
    theme_id = install_theme_from_git(repo)
    theme_ids << theme_id if theme_id
  else
    puts "Theme #{File.basename(repo, '.git')} already exists, skipping."
    theme_ids << Theme.where("name LIKE ?", "%#{File.basename(repo, '.git')}%").first.id
  end
end

# Install components
component_repos = [
  "https://github.com/bmc-core/discourse-custom-header-links-icons-component"
  "https://github.com/bmc-core/discourse-breadcrumb-links-component"
  "https://github.com/bmc-core/discourse-character-count-component"
  "https://github.com/bmc-core/discourse-right-sidebar-blocks-component"
  "https://github.com/bmc-core/discourse-new-topic-header-button-component"
  "https://github.com/bmc-core/discourse-gifs-component"
]

component_repos.each do |repo|
  component_name = File.basename(repo, ".git")
  unless theme_exists?(repo)
    install_theme_from_git(repo, "component")
  else
    puts "Component #{component_name} already exists, skipping."
  end
end

# Set the default theme (if themes were installed)
if theme_ids.any?
  # You can choose which theme to set as default
  default_theme_id = theme_ids.first
  SiteSetting.default_theme_id = default_theme_id
  puts "Set default theme ID to: #{default_theme_id}"
end

# Enable theme components on themes if needed
# This is how you would connect components to themes
# ThemeComponent.create!(theme_id: component_id, parent_theme_id: theme_id)

puts "Theme and component installation completed!"
