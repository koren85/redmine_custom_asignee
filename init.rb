require_dependency 'redmine_custom_asignee/issue_patch'
Redmine::Plugin.register :redmine_custom_asignee do
  name 'Redmine Custom Asignee plugin'
  author 'Author name'
  description 'This is a plugin for Redmine'
  version '0.0.1'
  url 'http://example.com/path/to/plugin'
  author_url 'http://example.com/about'

  Rails.configuration.to_prepare do
    unless Issue.included_modules.include? RedmineCustomAsignee::IssuePatch
      Issue.send(:include, RedmineCustomAsignee::IssuePatch)
    end
  end

end
