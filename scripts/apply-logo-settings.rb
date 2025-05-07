upload = UploadCreator.new(File.new('/shared/icons/logo.png'), 'logo.png').create_for(nil);
SiteSetting.site_logo_url = upload.url

upload = UploadCreator.new(File.new('/shared/icons/logo_small.png'), 'logo_small.png').create_for(nil);
SiteSetting.site_logo_small_url = upload.url

upload = UploadCreator.new(File.new('/shared/icons/favicon.png'), 'favicon.png').create_for(nil);
SiteSetting.site_favicon_url = upload.url

upload = UploadCreator.new(File.new('/shared/icons/large_icon.png'), 'large_icon.png').create_for(nil);
SiteSetting.site_large_icon_url = upload.url
