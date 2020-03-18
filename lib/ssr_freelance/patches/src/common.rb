require_relative './check_freelance_on-off'
require_relative './complete_field_check'
require_relative './role_and_assigned'
require_relative './status_to_check_paid'
require_relative './check_payment_info'
require_relative './issue_check'





def freelance_role_check_off # yes
  check = false
  id_field_freelance = Setting.plugin_freelance_helper['sunstrike_freelance_field_id'].to_i
  cf = (custom_field_values.map do |item|
    if item.custom_field.id == id_field_freelance
      item
    end
  end).compact
  if cf.first.value == '0' and assigned_to
    check = true
  end
  check
end


