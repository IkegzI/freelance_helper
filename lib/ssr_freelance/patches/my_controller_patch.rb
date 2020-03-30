require_dependency 'my_controller'
module SsrFreelance
  module Patches
    module MyControllerPatch
      def self.included(base)
        base.class_eval do
          alias_method :account, :ssr_account
        end
      end

      def ssr_account
        @user = User.current
        @pref = @user.pref
        if request.post?
          @user.safe_attributes = params[:user]
          @user.pref.safe_attributes = params[:pref]
          if @user.save
            @user.pref.save
            set_language_if_valid @user.language
            payment_change_on_freelance(@user)
            flash[:notice] = l(:notice_account_updated)
            redirect_to my_account_path
            return
          end
        end
      end

      # def payment_change_on_freelance(user)
      #   pay_all_id = Setting.plugin_freelance_helper['sunstrike_freelance_field_id'].to_i
      #   Issue.where(assigned_to_id: user.id).where(status_id: [1, 2]).each do |issue|
      #     issue.custom_field_values.each do |item|
      #       if item.custom_field.id == pay_all_id
      #         if item.value == '1'
      #           payment_info_change(issue)
      #         end
      #       end
      #     end
      #   end
      # end
      #
      # def payment_info_change(issue)
      #   wallet = User.find(issue.assigned_to_id).custom_field_values.map { |i| i.value if i.custom_field.id == Setting.plugin_freelance_helper['sunstrike_freelance_pay_wallet_user_field_id'].to_i }.compact.first
      #   acc = User.find(issue.assigned_to_id).custom_field_values.map { |i| i.value if i.custom_field.id == Setting.plugin_freelance_helper['sunstrike_freelance_pay_user_field_id'].to_i }.compact.first
      #   issue.custom_field_values.each do |item|
      #     if item.custom_field.id == Setting.plugin_freelance_helper['sunstrike_freelance_pay_issue_field_id'].to_i
      #       item.value = acc
      #     end
      #     if item.custom_field.id == Setting.plugin_freelance_helper['sunstrike_freelance_pay_wallet_issue_field_id'].to_i
      #       item.value = wallet
      #     end
      #     item
      #   end
      #   issue.save
      # end


    end
  end
end

# def freelance_on_custom(data)
#   check = false
#   data[:issue].custom_field_values.each do |item|
#     if item.custom_field.id == Setting.plugin_freelance_helper['sunstrike_freelance_field_status'].to_i
#       if item.value == '1'
#         check = true
#       end
#     end
#   end
#   check
# end
