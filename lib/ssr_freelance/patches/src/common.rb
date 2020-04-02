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
  if cf.first
    if cf.first.value == '0' and assigned_to
      check = true
    end
  end
  check
end


def freelance_field_exist
  field_id = {
      wallet: Setting.plugin_freelance_helper['sunstrike_freelance_pay_wallet_issue_field_id'].to_i,
      pay: Setting.plugin_freelance_helper['sunstrike_freelance_pay_issue_field_id'].to_i,
      status: Setting.plugin_freelance_helper['sunstrike_freelance_field_status'].to_i
  }
  check = false
  custom_field_values.each do |item|
    if field_id.values.include?(item.custom_field.id)
      check = true
    end
  end
  check
end


