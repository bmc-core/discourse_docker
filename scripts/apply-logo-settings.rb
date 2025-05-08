# Logo
file_path = "/shared/icons/logo.png"
file = File.open(file_path)
upload_creator = UploadCreator.new(file, "logo.png")
upload = upload_creator.create_for(Discourse.system_user.id)
SiteSetting.logo = upload

# Logo small
file_path = "/shared/icons/small_logo.png"
file = File.open(file_path)
upload_creator = UploadCreator.new(file, "small_logo.png")
upload = upload_creator.create_for(Discourse.system_user.id)
SiteSetting.logo_small = upload

# favicon
file_path = "/shared/icons/favicon.png"
file = File.open(file_path)
upload_creator = UploadCreator.new(file, "favicon.png")
upload = upload_creator.create_for(Discourse.system_user.id)
SiteSetting.favicon = upload

# Large icon
file_path = "/shared/icons/large_icon.png"
file = File.open(file_path)
upload_creator = UploadCreator.new(file, "large_icon.png")
upload = upload_creator.create_for(Discourse.system_user.id)
SiteSetting.large_icon = upload