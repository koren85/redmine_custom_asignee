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
        #   plugin_settings = Setting.plugin_redmine_custom_asignee
        #   included_user_ids = []
        #   excluded_user_ids = []
        #
        #   if plugin_settings && plugin_settings['group_data']
        #     plugin_settings['group_data'].each do |index, data|
        #       next unless Array(data['issue_status_id']).include?(self.status_id.to_s)
        #
        #       selected_group_ids = Array(data['group_id']).map(&:to_i)
        #
        #       if data['exclude_all_except_this'].present?
        #         included_user_ids += User.joins(:groups).where('users_groups_users_join.group_id IN (?)', selected_group_ids).pluck('users.id')
        #         all_other_group_ids = Group.all.ids - selected_group_ids
        #         excluded_user_ids += User.joins(:groups).where('users_groups_users_join.group_id IN (?)', all_other_group_ids).pluck('users.id')
        #       else
        #         excluded_user_ids += User.joins(:groups).where('users_groups_users_join.group_id IN (?)', selected_group_ids).pluck('users.id')
        #       end
        #     end
        #
        #     if included_user_ids.any?
        #       users = users & User.where(id: included_user_ids).to_a
        #     end
        #     if excluded_user_ids.any?
        #       users = users - User.where(id: excluded_user_ids).to_a
        #     end
        #   end
        #
        #   users.sort
        # end

        def assignable_users
          # 1. Получаем всех пользователей, которые могут быть назначены на проект.
          users = project.assignable_users.to_a

          # 2. Инициализация списков пользователей для включения и исключения.
          included_user_ids = []
          excluded_user_ids = []

          plugin_settings = Setting.plugin_redmine_custom_asignee

          if plugin_settings && plugin_settings['group_data']
            status_settings = plugin_settings['group_data'].select { |_, data| Array(data['issue_status_id']).include?(self.status_id.to_s) }

            # Если для текущего статуса нет настроек, возвращаем всех пользователей.
            return users if status_settings.empty?

            # 3. Обрабатываем сценарий с одной записью.
            if status_settings.count == 1
              data = status_settings.values.first
              group_ids = Array(data['group_id']).map(&:to_i)

              if data['exclude_all_except_this'].present?
                # 3a. Включаем пользователей этой группы и исключаем всех остальных.
                included_user_ids += User.joins(:groups).where('users_groups_users_join.group_id IN (?)', group_ids).pluck('users.id')
                excluded_user_ids += User.joins(:groups).where.not('users_groups_users_join.group_id IN (?)', group_ids).pluck('users.id')
              else
                # 3b. Исключаем пользователей этой группы.
                excluded_user_ids += User.joins(:groups).where('users_groups_users_join.group_id IN (?)', group_ids).pluck('users.id')
              end

              # 4. Обрабатываем сценарий с несколькими записями.
            else
              # 4a. Исключаем пользователей из групп без галки, если они не входят в группы с галкой.
              no_tick_groups = status_settings.select { |_, data| data['exclude_all_except_this'].blank? }.values.map { |data| Array(data['group_id']).map(&:to_i) }.flatten
              tick_groups = status_settings.select { |_, data| data['exclude_all_except_this'].present? }.values.map { |data| Array(data['group_id']).map(&:to_i) }.flatten

              excluded_user_ids += User.joins(:groups).where('users_groups_users_join.group_id IN (?) AND users.id NOT IN (?)', no_tick_groups, tick_groups).pluck('users.id')

              # 4b. Добавляем пользователей из групп с галкой.
              included_user_ids += User.joins(:groups).where('users_groups_users_join.group_id IN (?)', tick_groups).pluck('users.id')
            end
          end

          # Если у нас есть идентификаторы пользователей для включения
          if excluded_user_ids.any?
            users = users - User.where(id: excluded_user_ids).to_a
          end
             if included_user_ids.any?
                users = users & User.where(id: included_user_ids).to_a
              end

          users.sort


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
