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
            payment_change_on_freelance(@user) if Setting.plugin_freelance_helper['sunstrike_freelance_plugin_status'] == '0'
            flash[:notice] = l(:notice_account_updated)
            redirect_to my_account_path
            return
          end
        end
      end
    end
  end
end