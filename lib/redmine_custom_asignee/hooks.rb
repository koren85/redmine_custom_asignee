module RedmineCustomAsignee
  module Hooks
    class ViewIssuesFormDetailsBottomHook < Redmine::Hook::ViewListener
      render_on :view_issues_form_details_bottom, partial: 'redmine_custom_asignee/add_issue_buttons'
    end
  end
end
