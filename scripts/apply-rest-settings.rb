# themes
theme = Theme.find_by(name: "BMCCore")

if theme
  SiteSetting.default_theme_id = theme.id
end

# gamification leaderboard
lb = DiscourseGamification::GamificationLeaderboard.find(1)
if lb
  lb.update!(
    name: "Award",
    from_date: Date.parse("2025-04-29"),
    to_date: Date.parse("2025-08-29"),
    included_groups_ids: [10, 11, 12, 13, 14],
    excluded_groups_ids: [-4, 2, 3, 1],
    default_period: 0,
    period_filter_disabled: false
  )
end

# logo
upload = UploadCreator.new(File.new('/icons/logo_436x89.png'), 'logo_436x89.png').create_for(nil);
SiteSetting.site_logo_url = upload.url

upload = UploadCreator.new(File.new('/icons/logo_small.png'), 'logo_small.png').create_for(nil);
SiteSetting.site_logo_small_url = upload.url

upload = UploadCreator.new(File.new('/icons/favicon_32x32.png'), 'favicon_32x32.png').create_for(nil);
SiteSetting.site_favicon_url = upload.url
