require_dependency 'redmine_custom_asignee/issue_patch'
Redmine::Plugin.register :redmine_custom_asignee do
  name 'Redmine Custom Assignee plugin'
  author 'Chernyaev A.A'
  description 'This is a plugin for Redmine'
  version '0.0.4'
  url 'https://github.com/koren85/redmine_custom_asignee.git'
  author_url 'https://github.com/koren85/redmine_custom_asignee.git'


  settings partial: 'redmine_custom_asignee/settings', default: { 'group_data' => [] }


  Rails.configuration.to_prepare do
    unless Issue.included_modules.include? RedmineCustomAsignee::IssuePatch
      Issue.send(:include, RedmineCustomAsignee::IssuePatch)
    end
  end

end
