require_relative 'common'

# параметр “Фриланс (начислено)” пустой, равен нулю или меньше нуля
def freelance_cash_accrued_empty?
  #sunstrike_freelance_field_accrued
  check = false
  id_cash = Setting.plugin_freelance_helper['sunstrike_freelance_field_accrued'].to_i
  custom_field_values.each do |item|
    if item.custom_field.id == id_cash
      if item.value.to_f <= 0
        check = true
      end
    end
  end
  check
end

# параметр “Фриланс (выплачено)” пустой, равен нулю или меньше нуля
def freelance_cash_paid_empty?
  #sunstrike_freelance_field_paid
  check = false
  paid_id = Setting.plugin_freelance_helper['sunstrike_freelance_field_paid'].to_i
  custom_field_values.each do |item|
    if item.custom_field.id == paid_id
      if item.value.to_f <= 0
        check = true
      end
    end
  end
  check
end

def freelance_cash_paid_under_zero?
  #sunstrike_freelance_field_paid
  check = false
  paid_id = Setting.plugin_freelance_helper['sunstrike_freelance_field_paid'].to_i
  custom_field_values.each do |item|
    if item.custom_field.id == paid_id
      if item.value.to_f < 0
        check = true
      end
    end
  end
  check
end

# параметр “Фриланс статус” пустой
def status_payment_freelancer_empty?
  check = false
  status_id = Setting.plugin_freelance_helper['sunstrike_freelance_field_status'].to_i
  custom_field_values.each do |item|
    if item.custom_field.id == status_id and item.value == ""
      check = true
    end
  end
  check
end

# Фриланс статус имее значение выплачено
def payment_status_on_paid?
  check = false
  value_50 = Setting.plugin_freelance_helper['sunstrike_freelance_field_status_50']
  value_100 = Setting.plugin_freelance_helper['sunstrike_freelance_field_status_100']
  custom_field_values.each do |item|
    if item.value == value_50 or item.value == value_100
      check = true
    end
  end
  check
end

# Фриланс статус имее значение можно оплачивать
def payment_status_on_accrued?
  check = false
  value_prepayment = Setting.plugin_freelance_helper['sunstrike_freelance_field_prepayment']
  value_payment = Setting.plugin_freelance_helper['sunstrike_freelance_field_payment']
  custom_field_values.each do |item|
    if item.value == value_prepayment or item.value == value_payment
      check = true
    end
  end
  check
end

def check_amount_pay
  check = false
  paid_value = ''
  accrued_value = ''
  paid_id = Setting.plugin_freelance_helper['sunstrike_freelance_field_paid'].to_i
  accrued_id = Setting.plugin_freelance_helper['sunstrike_freelance_field_accrued'].to_i
  custom_field_values.each do |item|
    if item.custom_field.id == paid_id
      paid_value = item.value.to_f
    end
    if item.custom_field.id == accrued_id
      accrued_value = item.value.to_f
    end
  end
  if paid_value > accrued_value and paid_value > 0
    check = true
  end
  check
end


