require_relative 'common'

def freelance_changer(data)
  if freelancer?(data)
    freelance_on(data)
  else
    freelance_off(data)
  end
  data
end

def freelance_on(data)
  data[:issue].custom_field_values.each do |item|
    if item.custom_field.id == Setting.plugin_freelance_helper['sunstrike_freelance_field_id'].to_i
      if freelancer?(data)
        item.value = '1' if item.value_was != '1'
      end
    end
    payment_info_add(item, data[:issue].assigned_to_id) if change_assigned(data)
  end
end


def freelance_change_on(data)
  check = false
  data[:issue].custom_field_values.each do |item|
    if item.custom_field.id == Setting.plugin_freelance_helper['sunstrike_freelance_field_id'].to_i
      check = true if item.value == '1' and item.value_was != '1'
    end
  end
end


def freelance_off(data)
  if change_assigned(data)
    data[:issue].custom_field_values.each do |item|
      if item.custom_field.id == Setting.plugin_freelance_helper['sunstrike_freelance_field_id'].to_i
        unless field_check_complete(data)
          if payment_data(data)
            item.value = '0'
          end
        end
      end
      payment_info_destroy(item) if change_assigned(data) and payment_data(data)
    end
  end
  data
end

def change_assigned(data)
  data[:issue].assigned_to_id != Issue.find(data[:issue].id).assigned_to_id
end

def payment_info_add(item, usr)
  if item.custom_field.id == Setting.plugin_freelance_helper['sunstrike_freelance_pay_issue_field_id'].to_i and item.value_was = ''
    item.value = User.find(usr).custom_field_values.map { |i| i.value if i.custom_field.id == Setting.plugin_freelance_helper['sunstrike_freelance_pay_user_field_id'].to_i }.compact.first
  end
  if item.custom_field.id == Setting.plugin_freelance_helper['sunstrike_freelance_pay_wallet_issue_field_id'].to_i and item.value_was = ''
    item.value = User.find(usr).custom_field_values.map { |i| i.value if i.custom_field.id == Setting.plugin_freelance_helper['sunstrike_freelance_pay_wallet_user_field_id'].to_i }.compact.first
  end
  item
end

def payment_info_destroy(item)
  if item.custom_field.id == Setting.plugin_freelance_helper['sunstrike_freelance_pay_issue_field_id'].to_i
    item.value = ''
  end
  if item.custom_field.id == Setting.plugin_freelance_helper['sunstrike_freelance_pay_wallet_issue_field_id'].to_i
    item.value = ''
  end
end

def unchange_payment_info(data)
  check = false
  data[:issue].custom_field_values.each do |item|
    if item.custom_field.id == Setting.plugin_freelance_helper['sunstrike_freelance_pay_issue_field_id'].to_i
      if item.value == item.value_was or item.value == ''
        check = true
      end
    end
    if item.custom_field.id == Setting.plugin_freelance_helper['sunstrike_freelance_pay_wallet_issue_field_id'].to_i
      if item.value == item.value_was or item.value == ''
        check = true
      end
    end
  end
  check
end

def payment_data(data)
  check = true
  data[:issue].custom_field_values.each do |item|
    if item.custom_field.id == Setting.plugin_freelance_helper['sunstrike_freelance_pay_issue_field_id'].to_i
      if item.value != ''
        check = false
      end
    end
    if item.custom_field.id == Setting.plugin_freelance_helper['sunstrike_freelance_pay_wallet_issue_field_id'].to_i
      if item.value != ''
        check = false
      end
    end
  end
  check
end

