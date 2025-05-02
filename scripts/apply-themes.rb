theme = Theme.find_by(name: "BMCCore")

if theme
  SiteSetting.default_theme_id = theme.id
end
