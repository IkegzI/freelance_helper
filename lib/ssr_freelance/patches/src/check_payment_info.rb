require_relative 'common'

def deny_edit_payments_details
  check = false
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

