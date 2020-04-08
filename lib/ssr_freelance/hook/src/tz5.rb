require_relative 'common'

# автоматический расчёт и поставновка суммы в поле Фриланс (Выплачено)
def change_value_if_status(data)
  issue = data[:issue]
  data_cf = {
      status_freelance: '',
      status_freelance_id: Setting.plugin_freelance_helper['sunstrike_freelance_field_id'].to_i,
      accurued_id: Setting.plugin_freelance_helper['sunstrike_freelance_field_accrued'].to_i,
      accurued_value: '',

      status_payment_id: Setting.plugin_freelance_helper['sunstrike_freelance_field_status'].to_i,
      status_payment_value: '',
      status_payment_was_value: '',

      paid_id: Setting.plugin_freelance_helper['sunstrike_freelance_field_paid'].to_i,
      paid_value: ''
  }
  issue.custom_field_values.each do |item|
    if item.custom_field.id == data_cf[:status_freelance_id]
      data_cf[:status_freelance] = item.value.to_i
    end
    if item.custom_field.id == data_cf[:accurued_id]
      data_cf[:accurued_value] = item.value.to_f
    end
    if item.custom_field.id == data_cf[:status_payment_id]
      data_cf[:status_payment_was_value] = item.value_was
      data_cf[:status_payment_value] = item.value
    end
    if item.custom_field.id == data_cf[:paid_id]
      data_cf[:paid_value] = item.value.to_f
    end
  end
  binding.pry

  if data_cf[:status_freelance] == 1
    if data_cf[:status_payment_was_value] == Setting.plugin_freelance_helper['sunstrike_freelance_field_prepayment'] and data_cf[:status_payment_value] == Setting.plugin_freelance_helper['sunstrike_freelance_field_status_50']
      if data_cf[:paid_value] <= 0 and data_cf[:accurued_value] > 0
        issue.custom_field_values.each { |item| item.value = data_cf[:accurued_value] * 0.5 if item.custom_field.id == data_cf[:paid_id] }
      end
    end

    if data_cf[:status_payment_was_value] == Setting.plugin_freelance_helper['sunstrike_freelance_field_payment'] and data_cf[:status_payment_value] == Setting.plugin_freelance_helper['sunstrike_freelance_field_status_100']
      if (data_cf[:accurued_value] > 0 and data_cf[:paid_value] < data_cf[:accurued_value]) and data_cf[:accurued_value] > 0
        issue.custom_field_values.each { |item| item.value = data_cf[:accurued_value] if item.custom_field.id == data_cf[:paid_id] }
      end
    end
  end
  data[:issue] = issue
  data
  
end