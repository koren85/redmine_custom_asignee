class RedmineCustomAsignee::SettingsController < ApplicationController
  layout 'admin'
  before_action :require_admin

  def show
    @settings = Setting.redmine_custom_asignee
  end

  def update
    Setting.plugin_redmine_custom_asignee = params[:settings].permit!
    redirect_to plugin_settings_path('redmine_custom_asignee'), notice: l(:notice_successful_update)
  end


  # def update
  #   Setting.plugin_redmine_custom_asignee = params[:settings].permit!
  #   redirect_to plugin_settings_path('redmine_custom_asignee'), notice: l(:notice_successful_update)
  # end
end
