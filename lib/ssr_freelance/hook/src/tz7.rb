require_relative 'common'

def change_issue_status(data)
  check_pay_info = Setting.plugin_freelance_helper['sunstrike_freelance_field_accrued'].to_i
  data[:issue].custom_field_values.each do |item|
    if check_pay_info == item.custom_field.id
      if item.value.to_f > 0
        if data[:issue].status_id == 1 and Issue.find(data[:issue].id).status_id == 1
          data[:issue].status_id = 2
        end
      end
    end
  end
  data
end