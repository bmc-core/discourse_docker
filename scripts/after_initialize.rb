# after_initialize.rb
after_initialize do
  # Only run on first boot or when forced via env var
  # Define the icons to be set
  icons = {
    logo: "logo.png",
    logo_small: "logo_small.png",
    favicon: "favicon.png",
    large_icon: "large_icon.png"
  }

  # Process each icon
  icons.each do |setting_name, filename|
    # Only update if the setting is not set or if forced via environment variable
    if !SiteSetting.send(setting_name) || ENV['FORCE_LOGO_UPDATE'] == "1"
      icon_path = File.join(Rails.root, "shared", "icons", filename)

      if File.exist?(icon_path)
        # Create an upload for the icon
        upload = UploadCreator.new(
          File.open(icon_path),
          filename,
          type: "logo"
        ).create_for(Discourse.system_user.id)

        # Set the icon in site settings if upload succeeded
        if upload && upload.persisted?
          SiteSetting.send("#{setting_name}=", upload)
          Rails.logger.info "Custom #{setting_name} has been set successfully"
        else
          Rails.logger.error "Failed to set custom #{setting_name}"
        end
      else
        Rails.logger.warn "#{setting_name.to_s.humanize} file not found at #{icon_path}"
      end
    end
  end
end
