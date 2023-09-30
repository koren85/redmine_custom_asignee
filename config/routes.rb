Rails.application.routes.draw do
  post 'settings/plugin/redmine_custom_asignee', to: 'custom_asignee_settings#update'
end
