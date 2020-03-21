require_dependency 'issue'
require_relative './src/common'
module SsrFreelance
  module Patches
    module IssuePatch
      include Redmine::I18n

      def self.included(base)
        base.send(:include, InstanceMethods)
        base.class_eval do
          validate :ssr_validate
        end
      end

      module InstanceMethods

        def ssr_validate
          check = true
          check_error_role = false
          # #freelance
          # #Задачу больше делает не фрилансер? Чтобы изменить поле “Делает фрилансер” на “Нет” удалите информацию из полей “Фриланс (начислено)”, “Фриланс (выплачено)” и “Фриланс статус”
          # # роль - фрилансер, изменяем ассоциирующее поле stop_change_complete_field
          # errors.add :base, :stop_change_complete_field if freelance_check_complete_fields and freelance_role_check_change_turn_off and !(freelance_role_check) #freelance_check_off_complete_fields

          # #stop_change_field: "Тикет назначен на пользователя, работающего на фрилансе. Нельзя в поле 'Делает фрилансер' установить значение 'Нет'"
          # #пользователь - фрилансер               #не изменилось, значение нет
          if role_frelancer? and freelance_role_check_off
            errors.add :base, :stop_change_field
            check_error_role = true
          else
            # Краткое описание: запретить вносить информацию в поля “Фриланс (начислено)”, “Фриланс (выплачено)” и “Фриланс статус”,
            # если параметр “Делает фрилансер” равен “Нет”. Запретить выставлять параметр “Делает фрилансер” на “Нет”,
            # если заполнены поля “Фриланс (начислено)”, “Фриланс (выплачено)” и “Фриланс статус”.
            if freelance_check_complete_fields
              if freelance_role_change_to_off
                errors.add :base, :stop_change_complete_field
                check = false
              elsif freelance_role_off
                errors.add :base, :freelance_check_off_complete_fields
                check = false
              elsif assigned_nil?
                errors.add :base, :assigned_to_nil
                check = false
              elsif check_amount_pay
                errors.add :base, :status_to_check_payment
              end
            end
          end
          # параметр “Фриланс (начислено)” пустой, равен нулю или меньше нуля, система должна выдать ошибку при попытке сохранить любое из значений в поле “Фриланс статус” кроме пустого
          #settings_sunstrike_freelance_field_status
          # binding.pry
          unless status_payment_freelancer_empty?
            if check
              if freelance_cash_accrued_empty?
                errors.add :base, :status_to_check_accrued
              end
              if payment_status_on_paid?
                errors.add :base, :status_to_check_paid if freelance_cash_paid_empty?
              end
            end
          end
          unless freelance_cash_accrued_empty?
            errors.add :base, :status_to_check_status_issue if issue_status
          end

          errors.add :base, :assigned_nil_status_on if assigned_nil? and freelance_role_on_without_assigned
          # errors.add :base, :stop_change_payments_details if assigned_nil? and freelance_role_on_without_assigned
          errors.add :base, :stop_change_payments_details_deny if role_frelancer? and deny_edit_payments_details

          errors.add :base, :stop_change_payments_details if payments_details_check_add and freelance_role_off
        end
      end
    end
  end
end