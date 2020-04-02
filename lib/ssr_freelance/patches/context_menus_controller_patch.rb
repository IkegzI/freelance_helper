require_dependency 'context_menus_controller'
require_relative './src/freelance_update_payment_info'
module SsrFreelance
  module Patches
    module ContextMenusControllerPatch
      def self.included(base)
        base.class_eval do
          alias_method :issues, :ssr_issues
        end
      end

      def ssr_issues
        if (@issues.size == 1)
          @issue = @issues.first
          update_info_payment if Setting.plugin_freelance_helper['sunstrike_freelance_plugin_status'] == '0'
        end
        @issue_ids = @issues.map(&:id).sort

        @allowed_statuses = @issues.map(&:new_statuses_allowed_to).reduce(:&)

        @can = {:edit => @issues.all?(&:attributes_editable?),
                :log_time => (@project && User.current.allowed_to?(:log_time, @project)),
                :copy => User.current.allowed_to?(:copy_issues, @projects) && Issue.allowed_target_projects.any?,
                :add_watchers => User.current.allowed_to?(:add_issue_watchers, @projects),
                :delete => @issues.all?(&:deletable?)
        }

        @assignables = @issues.map(&:assignable_users).reduce(:&)
        @trackers = @projects.map { |p| Issue.allowed_target_trackers(p) }.reduce(:&)
        @versions = @projects.map { |p| p.shared_versions.open }.reduce(:&)

        @priorities = IssuePriority.active.reverse
        @back = back_url

        @options_by_custom_field = {}
        if @can[:edit]
          custom_fields = @issues.map(&:editable_custom_fields).reduce(:&).reject(&:multiple?).select { |field| field.format.bulk_edit_supported }
          custom_fields.each do |field|
            values = field.possible_values_options(@projects)
            binding.pry
            if values.present?
              @options_by_custom_field[field] = values
            end
          end
        end
        @safe_attributes = @issues.map(&:safe_attribute_names).reduce(:&)
        render :layout => false
      end

    end
  end
end
