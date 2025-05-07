require 'yaml'

tag_group_data = YAML.load_file(Rails.root.join('samples/tag_groups.yml'))

tag_group_data.each do |group_info|
  tags = group_info['tags'].map do |tag_name|
    Tag.find_or_create_by!(name: tag_name)
  end

  tag_group = TagGroup.find_or_create_by!(name: group_info['name'])
  tag_group.update!(
    tag_names: tags.map(&:name),
    one_per_topic: group_info['one_per_topic'] || false
  )

  puts "Created TagGroup: #{tag_group.name} with tags: #{tags.map(&:name).join(', ')}"
end
