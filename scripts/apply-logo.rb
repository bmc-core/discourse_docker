upload = UploadCreator.new(File.new('/shared/logo/logo.png'), 'logo.png').create_for(nil);
SiteSetting.logo_url = upload.url

upload = UploadCreator.new(File.new('/shared/logo/logo_small.png'), 'logo_small.png').create_for(nil);
SiteSetting.logo_small_url = upload.url

upload = UploadCreator.new(File.new('/shared/logo/favicon.png'), 'favicon.png').create_for(nil);
SiteSetting.favicon_url = upload.url
