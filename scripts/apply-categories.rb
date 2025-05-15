require 'yaml'

file_path = '/shared/categories.yml'
categories_data = YAML.load_file(file_path)

def apply_category_settings(category, data)
  # Style Type and Emoji
  if data["style_type"] && data["emoji"]
    category.style_type = data["style_type"]
    category.emoji = data["emoji"]
    category.save!
  end

  # Custom Fields
  if data["custom_fields"]
    data["custom_fields"].each do |key, value|
      category.custom_fields[key] = value
    end
    category.save_custom_fields
  end

  # Tag Groups
  if data["tag_groups"]
    data["tag_groups"].each do |tg|
      tag_group = TagGroup.find_by(name: tg)
      if tag_group && !category.tag_groups.include?(tag_group)
        category.tag_groups << tag_group
      end
    end
  end

  # Security
  if data["security"]
    category.category_groups.destroy_all
    data["security"].each do |sec|
      group = Group.find_by(name: sec["group"])
      if group
      category.category_groups.create!(group: group, permission_type: sec["permission_type"])
      end
    end
  end
end

def update_category_attributes(category, data)
  category.update!(
    color: data["color"],
    description: data["description"],
    position: data["position"],
    show_subcategory_list: data["show_subcategory_list"],
    subcategory_list_style: data["subcategory_list_style"],
    default_list_filter: data["default_list_filter"]
  )
end

def add_to_navigation_menu(category)
  ids = SiteSetting.default_navigation_menu_categories.split("|").map(&:to_i)
  unless ids.include?(category.id)
    ids << category.id
    SiteSetting.default_navigation_menu_categories = ids.join("|")
    puts "[Settings] added to navigation menu. (id: #{category.id})"
  else
    puts "[Settings] already in navigation menu."
  end
end

def add_scorable_category(category)
  ids = SiteSetting.scorable_categories.split("|").map(&:to_i)
  unless ids.include?(category.id)
    ids << category.id
    SiteSetting.scorable_categories = ids.join("|")
    puts "[Settings] added to scorable categories. (id: #{category.id})"
  else
    puts "[Settings] already in scorable categories."
  end
end

puts " "
categories_data["categories"].each do |cat_data|
  existing_parent = Category.find_by(name: cat_data["name"])
  puts "========================================================"
  if existing_parent
    puts "[Category] already exists, skip create: #{cat_data["name"]}"
    parent_category = existing_parent
    update_category_attributes(parent_category, cat_data)
  else
    puts "[Category] Creating: #{cat_data["name"]}"
    parent_category = Category.create!(
      name: cat_data["name"],
      color: cat_data["color"],
      user_id: eval(cat_data["user_id"]),
      description: cat_data["description"],
      position: cat_data["position"],
      show_subcategory_list: cat_data["show_subcategory_list"],
      subcategory_list_style: cat_data["subcategory_list_style"],
      default_list_filter: cat_data["default_list_filter"]
    )
  end
  apply_category_settings(parent_category, cat_data)
  add_to_navigation_menu(parent_category)
  add_scorable_category(parent_category)

  # Create Subcategories
  if cat_data["subcategories"]
    cat_data["subcategories"].each do |sub_data|
      #existing_sub = Category.find_by(name: sub_data["name"])
      existing_sub = Category.find_by(name: sub_data["name"], parent_category_id: parent_category.id)
      if existing_sub
        puts "[Subcategory] already exists, skip create: #{sub_data["name"]}"
        subcategory = existing_sub
        update_category_attributes(subcategory, sub_data)
        apply_category_settings(subcategory, sub_data)
      else
        puts "[Subcategory] creating: #{sub_data["name"]}"
        subcategory = Category.create!(
          name: sub_data["name"],
          color: sub_data["color"],
          user_id: eval(sub_data["user_id"]),
          position: sub_data["position"],
          parent_category_id: parent_category.id,
          default_list_filter: sub_data["default_list_filter"]
        )
      end
      apply_category_settings(subcategory, sub_data)
      add_scorable_category(subcategory)
    end
  end
end
puts "========================================================"
Category.find_by(name: "Staff").update!(position: 58)
puts "[Category] Update Staff position to 58"
Category.find_by(name: "General").update!(position: 59)
puts "[Category] Update General position to 59"
Category.find_by(name: "Site Feedback").update!(position: 60)
puts "[Category] Update Site Feedback position to 60"

# Remove Announcement from scorable categories
category = Category.find_by(name: "Announcement")
if category
  ids = SiteSetting.scorable_categories.split("|").map(&:to_i)
  if ids.delete(category.id)
    SiteSetting.scorable_categories = ids.join("|")
    puts "[Settings] scorable categories removed: #{category.name} (id: #{category.id})"
  else
    puts "[Settings] category ID not found in setting: #{category.id}"
  end
else
  puts "[Settings] category not found: Announcement"
end

puts "========================================================\n Apply categories successful!"