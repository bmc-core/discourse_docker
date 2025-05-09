require 'yaml'

file_path = '/shared/tag_groups.yml'
tags_groups_data = YAML.load_file(file_path)

tags_groups_data.each do |group_data|
  name = group_data["name"]
  one_per_topic = group_data["one_per_topic"]
  tags = group_data["tags"]

  # Check if the group already exists
  tag_group = TagGroup.find_by(name: name)
  if tag_group
    puts "========================================================"
    puts "[Group] already exists, skip create #{name} "
  else
    tag_group = TagGroup.new(name: name, one_per_topic: one_per_topic)
    if tag_group.save
      puts "========================================================"
      puts "[Group] create successful: #{name}"
    else
      puts "[Group] create failed: #{name}"
      puts tag_group.errors.full_messages
      next
    end
  end

  # Apply tags to TagGroup
  tags.each do |tag_name|
    # Check if the tag already exists
    tag = Tag.find_by_name(tag_name)
    unless tag
      tag = Tag.create!(name: tag_name)
      puts "[Tag] create successful: #{tag_name}"
    else
      puts "[Tag] already exists, skip create #{tag_name}"
    end

    # Check if the tag is already added to the group
    unless tag_group.tags.exists?(id: tag.id)
      tag_group.tags << tag
      puts "[Add] successful: #{tag_name} -> #{tag_group.name}"
    end
  end
  puts " "
  tag_group.save!
end
