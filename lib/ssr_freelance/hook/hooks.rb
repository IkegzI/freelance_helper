require_relative "../../ssr_freelance"
require_relative './src/common'
require_relative '../../../app/helpers/ssr_freelance_helper'
module SsrFreelance
  module Hooks
    module Status
      class SsrFreelanceHookListener < Redmine::Hook::ViewListener
          render_on(:view_issues_new_top, partial: 'freelance/role_fl')

          render_on(:view_issues_edit_notes_bottom, partial: 'freelance/role_fl')

          render_on(:view_issues_show_details_bottom, partial: 'freelance/role_fl')
          render_on(:view_issues_form_details_bottom, partial: 'freelance/role_fl')


          # controller issue hook create and update
          include SsrFreelanceHelper

          def controller_issues_save_dry(data = {})
            data = first_def(data)
          end

          def controller_issues_new_before_save(data = {})
            controller_issues_save_dry(data)
          end

          #
          def controller_issues_edit_before_save(data = {})
            controller_issues_save_dry(data)
          end

          #
          #

          def controller_issues_bulk_edit_before_save(data = {})
            controller_issues_save_dry(data)
          end

          private

          def first_def(data)
            data = freelance_changer(data) if Setting.plugin_freelance_helper['sunstrike_freelance_plugin_status'] == '0'

            data[:issue] = change_value_if_status(data[:issue]) if Setting.plugin_freelance_helper['sunstrike_freelance_plugin_status'] == '0'

            data = change_issue_status(data) if Setting.plugin_freelance_helper['sunstrike_freelance_plugin_status'] == '0'
            data = freelance_custom_field_change(data)
            data
          end

        end


    end
  end
end


