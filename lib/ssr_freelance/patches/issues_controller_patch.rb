require_dependency 'issues_controller'
require_relative './src/freelance_update_payment_info'
module SsrFreelance
  module Patches
    module IssuesControllerPatch
      def self.included(base)
        base.class_eval do
          helper :ssr_freelance
          helper :ssr_freelance_pay
          alias_method :show, :ssr_show
        end
      end

      def ssr_show
        @journals = @issue.visible_journals_with_index
        @changesets = @issue.changesets.visible.preload(:repository, :user).to_a
        @relations = @issue.relations.select {|r| r.other_issue(@issue) && r.other_issue(@issue).visible? }
        if User.current.wants_comments_in_reverse_order?
          @journals.reverse!
          @changesets.reverse!
        end

        if User.current.allowed_to?(:view_time_entries, @project)
          Issue.load_visible_spent_hours([@issue])
          Issue.load_visible_total_spent_hours([@issue])
        end

        respond_to do |format|
          format.html {
            @allowed_statuses = @issue.new_statuses_allowed_to(User.current)
            @priorities = IssuePriority.active
            @time_entry = TimeEntry.new(:issue => @issue, :project => @issue.project)
            @relation = IssueRelation.new
            retrieve_previous_and_next_issue_ids
            render :template => 'issues/show'
          }
          format.api
          format.atom { render :template => 'journals/index', :layout => false, :content_type => 'application/atom+xml' }
          format.pdf  {
            send_file_headers! :type => 'application/pdf', :filename => "#{@project.identifier}-#{@issue.id}.pdf"
          }
        end
      end

    end
  end
end