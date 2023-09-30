class CustomAsigneeSettingsController < ApplicationController
  before_action :require_admin
  before_action :find_settings, only: [:show, :update]

  def show
    # Настройки уже загружены благодаря before_action :find_settings
    render 'redmine_custom_asignee/settings'
  end


  def update
    if request.post?
      # Получаем настройки из params
      settings = params.require(:settings).permit(group_data: [:issue_status_id, :group_id])

      # Преобразуем group_data в массив
      group_data = settings[:group_data].values

      # Сохраняем настройки
      Setting.plugin_redmine_custom_asignee = { 'group_data' => group_data }

      flash[:notice] = l(:notice_successful_update)
    end
    redirect_to plugin_settings_path(:redmine_custom_asignee)
  end

  private

  def find_settings
    @settings = Setting.plugin_redmine_custom_asignee || {}
  end
end
