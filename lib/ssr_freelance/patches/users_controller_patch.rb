require_dependency 'users_controller'
module SsrFreelance
  module Patches
    module UsersControllerPatch
      def self.included(base)
        base.class_eval do
          alias_method :update, :ssr_update
        end
      end
      
      def ssr_update
        if params[:user][:password].present? && (@user.auth_source_id.nil? || params[:user][:auth_source_id].blank?)
          @user.password, @user.password_confirmation = params[:user][:password], params[:user][:password_confirmation]
        end
        @user.safe_attributes = params[:user]
        # Was the account actived ? (do it before User#save clears the change)
        was_activated = (@user.status_change == [User::STATUS_REGISTERED, User::STATUS_ACTIVE])
        # TODO: Similar to My#account
        @user.pref.safe_attributes = params[:pref]
        if @user.save
          @user.pref.save
          payment_change_on_freelance(@user)

          if was_activated
            Mailer.account_activated(@user).deliver
          elsif @user.active? && params[:send_information] && @user != User.current
            Mailer.account_information(@user, @user.password).deliver
          end

          respond_to do |format|
            format.html {
              flash[:notice] = l(:notice_successful_update)
              redirect_to_referer_or edit_user_path(@user)
            }
            format.api  { render_api_ok }
          end
        else
          @auth_sources = AuthSource.all
          @membership ||= Member.new
          # Clear password input
          @user.password = @user.password_confirmation = nil

          respond_to do |format|
            format.html { render :action => :edit }
            format.api  { render_validation_errors(@user) }
          end
        end
      end
      
    end
  end
end
