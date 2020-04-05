require_relative 'common'

# Setting.plugin_freelance_helper['sunstrike_freelance_pay_wallet_issue_field_id']
# Setting.plugin_freelance_helper['sunstrike_freelance_pay_issue_field_id']
# 
def deny_edit_payments_details
  check = false
  id_cf = {
      payment: Setting.plugin_freelance_helper['sunstrike_freelance_pay_issue_field_id'].to_i,
      wallet: Setting.plugin_freelance_helper['sunstrike_freelance_pay_wallet_issue_field_id'].to_i
  }
  data_cf = {}
  data_cf = payment_info_user_data
  data_cf[:issue_payment] = ''
  data_cf[:issue_wallet] = ''
  custom_field_values.each do |item|
    if id_cf[:payment] == item.custom_field_id
      data_cf[:issue_payment] = item.value
    end
    if id_cf[:wallet] == item.custom_field_id
      data_cf[:issue_wallet] = item.value
    end
  end

  if data_cf[:issue_payment] != data_cf[:user_payment]
    check = true
  end

  if data_cf[:issue_wallet] != data_cf[:user_wallet]
    check = true
  end

  # if (item.value != item.value_was) and item.value_was != ''
  #   check = true
  # end
  check
end

def payment_info_user_data
  id_cf = {
      payment: Setting.plugin_freelance_helper['sunstrike_freelance_pay_user_field_id'].to_i,
      wallet: Setting.plugin_freelance_helper['sunstrike_freelance_pay_wallet_user_field_id'].to_i
  }
  user_payment = user_custom_field_exists?(id_cf[:payment])
  user_wallet = user_custom_field_exists?(id_cf[:wallet])
  {
      user_payment: user_payment,
      user_wallet: user_wallet
  }
end

def user_custom_field_exists?(field)
  unless User.find(assigned_to_id).custom_values.find_by(custom_field_id: field).nil?
     User.find(assigned_to_id).custom_values.find_by(custom_field_id: field).value
   else
     ''
   end
end

def payments_details_check_add
  # Setting.plugin_freelance_helper['sunstrike_freelance_pay_wallet_issue_field_id']
  # Setting.plugin_freelance_helper['sunstrike_freelance_pay_issue_field_id']
  check = false
  custom_field_values.each do |item|
    if item.custom_field.id == Setting.plugin_freelance_helper['sunstrike_freelance_pay_issue_field_id'].to_i
      if item.value != ''
        check = true
      end
    end
    if item.custom_field.id == Setting.plugin_freelance_helper['sunstrike_freelance_pay_wallet_issue_field_id'].to_i
      if item.value != ''
        check = true
      end
    end
  end
  check
end

