require_relative 'common'

def freelance_changer(data)
  if freelancer?(data)
    data = freelance_on(data)
  else
    data = freelance_off(data)
    data = freelance_payment_info_add_with_custom_on(data) if freelance_on_custom(data)
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
  data
end

def freelance_on_custom(data)
  check = false
  data[:issue].custom_field_values.each do |item|
    if item.custom_field.id == Setting.plugin_freelance_helper['sunstrike_freelance_field_id'].to_i
      if item.value == '1'
        check = true
      end
    end
  end
  check
end

  def freelance_payment_info_add_with_custom_on(data)
    usr = data[:issue].assigned_to_id
    data[:issue].custom_field_values.each do |item|
      payment_info_add(item, usr)
    end
    data
  end



def freelance_change_on(data)
  check = true
  field_id = Setting.plugin_freelance_helper['sunstrike_freelance_field_id']
  data[:issue].custom_field_values.each do |item|
    if item.custom_field.id == field_id.to_i
      check = false if data[:params][:issue][:custom_field_values][field_id] == '1'
    end
  end
  check
end


def freelance_off(data)
  if change_assigned(data) and payment_info_non_change(data)
    data[:issue].custom_field_values.each do |item|
      if item.custom_field.id == Setting.plugin_freelance_helper['sunstrike_freelance_field_id'].to_i
        unless field_check_complete(data)
          item.value = '0'
        end
      end
      # if change_assigned(data) and change_payment_data(data)
    end
    data = payment_info_destroy(data)
  elsif data[:issue].assigned_to_id.nil?
    data = payment_info_destroy(data)
  elsif data[:issue].assigned_to_id and !freelance_on_custom(data)
    data = payment_info_destroy(data)
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

def payment_info_destroy(data)
  data[:issue].custom_field_values.each do |item|
    if item.custom_field.id == Setting.plugin_freelance_helper['sunstrike_freelance_pay_issue_field_id'].to_i
      item.value = ''
    end
    if item.custom_field.id == Setting.plugin_freelance_helper['sunstrike_freelance_pay_wallet_issue_field_id'].to_i
      item.value = ''
    end
  end
  data
end

def payment_info_non_change(data)
  check = []
  check[0] = false
  pay_issue_id = Setting.plugin_freelance_helper['sunstrike_freelance_pay_issue_field_id'].to_i
  pay_wallet_id = Setting.plugin_freelance_helper['sunstrike_freelance_pay_wallet_issue_field_id'].to_i
  pay_issue_value = Issue.find(data[:issue].id).custom_field_values.map { |item| item.value if item.custom_field.id == pay_issue_id }.compact.pop
  pay_wallet_value = Issue.find(data[:issue].id).custom_field_values.map { |item| item.value if item.custom_field.id == pay_wallet_id }.compact.pop
  data[:issue].custom_field_values.each do |item|
    if item.custom_field.id == pay_issue_id
      if item.value == pay_issue_value
        check[0] = true
      end
    end
    if item.custom_field.id == pay_wallet_id
      if item.value == pay_wallet_value
        check[1] = true
      end
    end
  end
  if check.uniq.size == 1 and check.first
    return true
  else
    return false
  end
end

def change_payment_data(data)
  check = true
  if data[:params][:issue][:custom_field_values]
    pay_issue_id = Setting.plugin_freelance_helper['sunstrike_freelance_pay_issue_field_id']
    pay_wallet_id = Setting.plugin_freelance_helper['sunstrike_freelance_pay_wallet_issue_field_id']
    data[:issue].custom_field_values.each do |item|
      if item.custom_field.id == pay_issue_id.to_i
        if item.value == data[:params][:issue][:custom_field_values][pay_issue_id]
          check = false
        end
      end
      if item.custom_field.id == pay_wallet_id.to_i
        if item.value == data[:params][:issue][:custom_field_values][pay_wallet_id]
          check = false
        end
      end
    end
  end
  check
end

