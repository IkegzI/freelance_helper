require_relative 'common'

# назначение фрилансеру, переключение на off
def freelance_role_change_to_off # yes
  check = false
  id_field_freelance = Setting.plugin_freelance_helper['sunstrike_freelance_field_id'].to_i
  cf = (custom_field_values.map do |item|
    if item.custom_field.id == id_field_freelance
      item
    end
  end).compact
  if cf.first.value == '0' and cf.first.value_was == '1' and assigned_to
    check = true
  end
  check
end

# назначение фрилансеру, переключение на on
def freelance_role_change_to_on # yes
  check = false
  id_field_freelance = Setting.plugin_freelance_helper['sunstrike_freelance_field_id'].to_i
  cf = (custom_field_values.map do |item|
    if item.custom_field.id == id_field_freelance
      item
    end
  end).compact
  if cf.first.value == '1' and cf.first.value_was != '1' and assigned_to
    check = true
  end
  check
end

# назначение фрилансеру off
def freelance_role_off # yes
  check = false
  id_field_freelance = Setting.plugin_freelance_helper['sunstrike_freelance_field_id'].to_i
  cf = (custom_field_values.map do |item|
    if item.custom_field.id == id_field_freelance
      item
    end
  end).compact
  unless assigned_to.nil?
    if cf.first.value == '0'
      check = true
    end
  end
  check
end

# назначение фрилансеру on
def freelance_role_on # yes
  check = false
  id_field_freelance = Setting.plugin_freelance_helper['sunstrike_freelance_field_id'].to_i
  cf = (custom_field_values.map do |item|
    if item.custom_field.id == id_field_freelance
      item
    end
  end).compact
  if cf.first.value == '1' and assigned_to
    check = true
  end
  check
end

# назначение фрилансеру on без проверки назначен ли кто-либо
def freelance_role_on_without_assigned # yes
  check = false
  id_field_freelance = Setting.plugin_freelance_helper['sunstrike_freelance_field_id'].to_i
  cf = (custom_field_values.map do |item|
    if item.custom_field.id == id_field_freelance
      item
    end
  end).compact
  if cf.first.value == '1'
    check = true
  end
  check
end