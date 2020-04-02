class SsrFreelanceController < ApplicationController
  require_relative '../helpers/ssr_freelance_helper.rb'
  include SsrFreelanceHelper

  def delete
    a = SsrFreelanceSetting.find_by(role_id: request.url.split("/").last.to_i)
    if a
      a.destroy
    end
    redirect_to plugin_settings_path('freelance_helper')
  end

  def add
    SsrFreelanceSetting.create(role_id: request.url.split("/").last.to_i, freelance_role: true)
    redirect_to plugin_settings_path('freelance_helper')
  end

  def user_role_freelance?
    check = true if params
    if check
      user = User.find(params['check_user_id'].to_i)
      if params['project_select'] == ''
        project = Project.find(params['project_id'].to_i) if params['project_id']
      else
        project = Project.find(params['project_select'].to_i) if params['project_select']
      end
      param_issue = params[:issue_id].to_i
      if param_issue > 0
        issue = Issue.find(param_issue)
      end
      if project
        begin
          role_user_ids = Member.where(user_id: user.id).find_by(project_id: project.id).role_ids
        rescue
          role_user_ids = []
        end
      end
      role_ids_custom = SsrFreelanceSetting.all.map { |item| item.role_id }.compact
      check = (role_user_ids.map { |item| 1 if role_ids_custom.include?(item) }).compact.pop || 2
      if issue
        if check == 2
          # if project.issues.find(issue).custom_values.find_by(custom_field_id: Setting.plugin_freelance_helper['sunstrike_freelance_field_id'].to_i).value.to_i == 1 and project.issues.find(issue).assigned_to.id
          if project.issues.find(issue).custom_values.find_by(custom_field_id: Setting.plugin_freelance_helper['sunstrike_freelance_field_id'].to_i).value.to_i == 1 and project.issues.find(issue).assigned_to.id == user.id
            check = 3
          else
            check = 2
          end
        end
      end
    end
    respond_to do |format|
      format.html {
        render text: check
      }
    end
  end

  def user_pay_freelance
    check = false
    user_pay_wallet = ''
    user_pay_type = ''
    custom_field_wallet = CustomField.where(type: 'UserCustomField').find(Setting.plugin_freelance_helper['sunstrike_freelance_pay_wallet_user_field_id'].to_i)
    custom_field_type = CustomField.where(type: 'UserCustomField').find(Setting.plugin_freelance_helper['sunstrike_freelance_pay_user_field_id'].to_i)
    custom_field_wallet_issue = CustomField.where(type: 'IssueCustomField').find(Setting.plugin_freelance_helper['sunstrike_freelance_pay_wallet_issue_field_id'].to_i)
    custom_field_type_issue = CustomField.where(type: 'IssueCustomField').find(Setting.plugin_freelance_helper['sunstrike_freelance_pay_issue_field_id'].to_i)
    a = []
    if params['check_user_id']
      user = User.find(params['check_user_id'].to_i)
      if params['project_select'] == ''
        project = Project.find(params['project_id'].to_i)
      else
        project = Project.find(params['project_select'].to_i)
      end
      if project
        role_ids_custom = SsrFreelanceSetting.all.map { |item| item.role_id }.compact
        check = (Member.where(user_id: user.id).find_by(project_id: project.id).role_ids.map { |item| true if role_ids_custom.include?(item) }).compact.pop if Member.where(user_id: user.id).find_by(project_id: project.id)
      end
      if check or params[:freelance_role_custom] == '1'
        user_pay_wallet = user.custom_values.find_by(custom_field_id: custom_field_wallet.id) || ''
        user_pay_type = user.custom_values.find_by(custom_field_id: custom_field_type.id) || ''
      end
      # if params[:issue_id] != '' and change_assigned_user
      # if params[:issue_id] != ''
      #   if user_pay_wallet == ''
      #     user_pay_wallet = Issue.find(params[:issue_id]).custom_values.find_by(custom_field_id: custom_field_wallet_issue.id)
      #   end
      #   if user_pay_type == ''
      #     user_pay_type = Issue.find(params[:issue_id]).custom_values.find_by(custom_field_id: custom_field_type_issue.id)
      #   end
      # end
    end

    # if check != []
    a << {number: custom_field_wallet_issue.id, value: user_pay_wallet == '' ? '' : user_pay_wallet.value}
    a << {number: custom_field_type_issue.id, value: user_pay_type == '' ? '' : user_pay_type.value}
    a << {number: 666, value: check}
    # else
    #   a << {number: custom_field_wallet_issue.id, value: ''}
    #   a << {number: custom_field_type_issue.id, value: ''}
    # end


    respond_to do |format|
      format.html {
        render json: a.to_json, status: 200
      }
    end
  end

  def addfield
    SsrFreelanceFields.create(field_id: request.url.split("/").last.to_i)
    redirect_to plugin_settings_path('sunstrike_redmine_freelance_plg')
  end

  def deletefield
    a = SsrFreelanceFields.find_by(field_id: request.url.split("/").last.to_i)
    if a
      a.destroy
    end
    redirect_to plugin_settings_path('sunstrike_redmine_freelance_plg')
  end

  def pay_cash
    value_id = Setting.plugin_freelance_helper['sunstrike_freelance_field_status'].to_i
    value_50 = Setting.plugin_freelance_helper['sunstrike_freelance_field_status_50']
    value_100 = Setting.plugin_freelance_helper['sunstrike_freelance_field_status_100']
    value = 'non'
    value_issue = 'non'
    arr = status_select
    index = (0..arr.size).find_all { |item| arr[item] == params['value_status'] }.first
    issue = Issue.find(params[:issue_id])
    id_field = Setting.plugin_freelance_helper['sunstrike_freelance_field_accrued'].to_i
    issue.custom_field_values.each do |item|
      if value_id == item.custom_field.id
        if item.value == arr[index - 1]
          issue.custom_field_values.each do |item|
            if item.custom_field.id == id_field
              if params['value_status'] == value_50
                value = item.value.to_f * 0.5
              elsif params['value_status'] == value_100
                value = item.value.to_f
              end
            end
          end
        end
      end
    end

    respond_to do |format|
      format.html {
        if value != 'non'
          if value > 0 and value != value.to_i
            render json: value.round(2).to_json, status: 200
          else
            render json: value.to_i.to_json, status: 200
          end
        else
          render json: value.to_i.to_json, status: 404
        end
      }
    end
  end

  def change_assigned_user
    Issue.find(params[:issue_id].to_i).assigned_to.id == params[:user_select_id].to_i
  end

  # def payment_info_non_change(issue)
  #   check = []
  #   check[0] = false
  #   pay_issue_id = Setting.plugin_freelance_helper['sunstrike_freelance_pay_issue_field_id'].to_i
  #   pay_wallet_id = Setting.plugin_freelance_helper['sunstrike_freelance_pay_wallet_issue_field_id'].to_i
  #   pay_issue_value = Issue.find(issue.id).custom_field_values.map { |item| item.value if item.custom_field.id == pay_issue_id }.compact.pop
  #   pay_wallet_value = Issue.find(issue.id).custom_field_values.map { |item| item.value if item.custom_field.id == pay_wallet_id }.compact.pop
  #   issue.custom_field_values.each do |item|
  #     if item.custom_field.id == pay_issue_id
  #       if item.value.to_i != 0
  #         check[0] = true
  #       end
  #     end
  #     if item.custom_field.id == pay_wallet_id
  #       if item.value == pay_wallet_value
  #         check[1] = true
  #       end
  #     end
  #   end
  #   if check.uniq.size == 1 and check.first
  #     return true
  #   else
  #     return false
  #   end
  # end


end
