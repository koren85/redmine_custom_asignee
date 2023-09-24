module RedmineCustomAsignee

    module IssuePatch
      def self.included(base)
        base.extend(ClassMethods)
        base.send(:include, InstanceMethods)

        base.class_eval do
          unloadable
          safe_attributes 'assigned_to_id'

          def assignable_users
            users = project.assignable_users.to_a
            excluded_group = Group.find_by(lastname: 'Руководители отделов')
            if excluded_group
              users -= excluded_group.users
            end
            users << author if author && author.active? && !users.include?(author)
            users << assigned_to if assigned_to && assigned_to.active? && !users.include?(assigned_to)
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
