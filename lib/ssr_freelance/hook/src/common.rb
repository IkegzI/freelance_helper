require_relative 'tz1'
require_relative 'tz2'
require_relative 'tz5'
require_relative 'tz7'

def freelancer?(data)
  check = false
  if data[:issue].assigned_to_id and data[:issue].project
    project = data[:issue].project
    if project and data[:issue].assigned_to
      user_id = data[:issue].assigned_to.id
      if user_id
        begin
          role_ids_data = Member.where(user_id: user_id).find_by(project_id: project.id).role_ids
        rescue
          role_ids_data = []
        end
      end
    else
      role_ids_data = data[:issue].assigned_to.roles.ids if data[:issue].assigned_to
    end
    role_ids_data.each do |item|
      if SsrFreelanceSetting.where(role_id: item) != []
        check = true
      end
    end
  end
  check
end

def field_check_complete(data)
  check = false
  hash = {
      accrued_id: Setting.plugin_freelance_helper['sunstrike_freelance_field_accrued'].to_i,
      paid_id: Setting.plugin_freelance_helper['sunstrike_freelance_field_paid'].to_i,
      status_id: Setting.plugin_freelance_helper['sunstrike_freelance_field_status'].to_i,
  }

  data[:issue].custom_field_values.each do |item|
    if hash.values.include?(item.custom_field.id) and item.value.scan(/[а-яА-Яa-zA-Z]+/).size > 0
      check = true
    end
  end
  check
end