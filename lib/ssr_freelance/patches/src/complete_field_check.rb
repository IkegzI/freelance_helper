require_relative 'common'


# заполненность полей
def freelance_check_complete_fields # yes
  check = false
  fields_ids = SsrFreelanceHelper.mark_custom_field_freelance.map { |item| item.last }
  custom_field_values.map do |item|
    if fields_ids.include?(item.custom_field.id)
      if item.value.to_f != 0 or item.value.scan(/[а-яА-Яa-zA-Z]+/).size > 0
        check = true
      end
    end
  end
  check
end

def freelance_check_complete_fields_strings # yes
  check = false
  fields_ids = SsrFreelanceHelper.mark_custom_field_pay_freelance.map { |item| item.last }
  custom_field_values.map do |item|
    if fields_ids.include?(item.custom_field.id)
      if item.value.scan(/[а-яА-Яa-zA-Z]+/).size > 0
        check = true
      end
    end
  end
  check
end





def freelance_check_complete_field_string(field_id)
  check = false
  custom_field_values.map do |item|
    if field_id == item.custom_field.id
      if item.value.scan(/[а-яА-Яa-zA-Z]+/).size > 0
        check = true
      end
    end
  end
  check
end




