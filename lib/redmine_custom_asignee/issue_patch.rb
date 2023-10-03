module RedmineCustomAsignee

  module IssuePatch
    def self.included(base)
      base.extend(ClassMethods)
      base.send(:include, InstanceMethods)

      base.class_eval do
        unloadable
        safe_attributes 'assigned_to_id'

        # def assignable_users
        #   users = project.assignable_users.to_a
        #
        #   # Получаем сохраненные настройки плагина
        #   plugin_settings = Setting.plugin_redmine_custom_asignee
        #
        #   excluded_user_ids = []
        #
        #   # Проверяем, имеются ли настройки для статуса текущей задачи
        #   if plugin_settings && plugin_settings['group_data']
        #     plugin_settings['group_data'].each do |index, data|
        #       if data['issue_status_id'].to_s == self.status_id.to_s
        #         # Добавляем всех пользователей из группы, связанной со статусом текущей задачи, в список исключения
        #         group = Group.find_by(id: data['group_id'].to_i)
        #         excluded_user_ids += group.users.pluck(:id) if group
        #       end
        #     end
        #   end
        #
        #   # Исключаем пользователей из списка назначаемых
        #   users.reject! { |user| excluded_user_ids.include?(user.id) }
        #
        #   #  users << author if author && author.active? && !users.include?(author)
        #   #   users << assigned_to if assigned_to && assigned_to.active? && !users.include?(assigned_to)
        #
        #   users.sort
        # end

        def assignable_users
          users = project.assignable_users.to_a

          plugin_settings = Setting.plugin_redmine_custom_asignee
          excluded_user_ids = []

          if plugin_settings && plugin_settings['group_data']
            plugin_settings['group_data'].each do |index, data|
              if data['issue_status_id'].to_s == self.status_id.to_s
                group = Group.find_by(id: data['group_id'].to_i)
                if data['exclude_all_except_this'].present?
                  all_other_group_ids = Group.all.ids - [group.id]
                  all_other_group_users = User.joins(:groups).where('users_groups_users_join.group_id IN (?)', all_other_group_ids).pluck('users.id')
                  excluded_user_ids += all_other_group_users
                else
                  excluded_user_ids += group.users.pluck(:id) if group
                end
              end
            end
          end

          users.reject! { |user| excluded_user_ids.include?(user.id) }
          users.sort
        end

      end
    end

    module ClassMethods
    end

    module InstanceMethods
    end
  end

end
