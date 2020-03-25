def update_info_payment_freelance_role?
  if @issue.project
    begin
      role_user_ids = Member.where(user_id: @issue.assigned_to).find_by(project_id: @issue.project.id).role_ids
    rescue
      role_user_ids = []
    end
  end
  role_ids_custom = SsrFreelanceSetting.all.map { |item| item.role_id }.compact
  check = (role_user_ids.map { |item| true if role_ids_custom.include?(item) }).compact.pop || false
end

def update_info_payment_freelance_on?
  check = false
  id_field_freelance = Setting.plugin_freelance_helper['sunstrike_freelance_field_id'].to_i
  cf = (@issue.custom_field_values.map do |item|
    if item.custom_field.id == id_field_freelance
      item
    end
  end).compact
  if cf.first.value == '1' and @issue.assigned_to
    check = true
  end
  check
end

def update_info_payment_status_on_paid?
  check = false
  value_payment = Setting.plugin_freelance_helper['sunstrike_freelance_field_status_100']
  @issue.custom_field_values.each do |item|
    if item.value != value_payment
      check = true
    end
  end
  check
end

def update_info_payment_allow?
  update_info_payment_status_on_paid? and update_info_payment_freelance_role?
end


def update_info_payment
  if update_info_payment_allow?
    user_payment_value = ''
    user_wallet_value = ''
    user_payment_id = Setting.plugin_freelance_helper['sunstrike_freelance_pay_user_field_id'].to_i
    user_wallet_id = Setting.plugin_freelance_helper['sunstrike_freelance_pay_wallet_user_field_id'].to_i
    issue_payment_id = Setting.plugin_freelance_helper['sunstrike_freelance_pay_issue_field_id'].to_i
    issue_wallet_id = Setting.plugin_freelance_helper['sunstrike_freelance_pay_wallet_issue_field_id'].to_i
    @issue.assigned_to.custom_field_values.each do |item|
      user_payment_value = item.value if user_payment_id == item.custom_field.id
      user_wallet_value = item.value if user_wallet_id == item.custom_field.id
    end
    @issue.custom_field_values.each do |item|
      if issue_payment_id == item.custom_field.id and item.value != user_payment_value
        item.value = user_payment_value #if item.value != user_payment_value
      end
      if issue_wallet_id == item.custom_field.id and item.value != user_wallet_value
        item.value = user_wallet_value # if item.value != user_wallet_value
      end
    end
    @issue.save
  end
end
