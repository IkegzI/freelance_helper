require_relative 'common'

# Setting.plugin_freelance_helper['sunstrike_freelance_pay_wallet_issue_field_id']
# Setting.plugin_freelance_helper['sunstrike_freelance_pay_issue_field_id']
# 
def deny_edit_payments_details
  check = false
  id_cf = {
      payment:  Setting.plugin_freelance_helper['sunstrike_freelance_pay_issue_field_id'].to_i,
      wallet: Setting.plugin_freelance_helper['sunstrike_freelance_pay_wallet_issue_field_id'].to_i
  }
  custom_field_values.each do |item|
    if id_cf.values.include?(item.custom_field.id) and (item.value != item.value_was)
      check = true
    end
  end
  check
end