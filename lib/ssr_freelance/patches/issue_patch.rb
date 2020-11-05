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
          if Setting.plugin_freelance_helper['sunstrike_freelance_plugin_status'] == '0'
            check = true
            check_error_role = true
            check_error_pay = true
            check_error_status = true
            check_correct = true
            accrued_id = Setting.plugin_freelance_helper['sunstrike_freelance_field_accrued'].to_i
            paid_id = Setting.plugin_freelance_helper['sunstrike_freelance_field_paid'].to_i

            # #stop_change_field: "Тикет назначен на пользователя, работающего на фрилансе. Нельзя в поле 'Делает фрилансер' установить значение 'Нет'"
            # #пользователь - фрилансер               #не изменилось, значение нет
            if freelance_check_complete_fields_strings and errors.messages.size == 0
              #проверка на внесение буквенных символов в строке
              errors.add :base, :status_to_check_correct_accrued if freelance_check_complete_field_string(accrued_id)
              errors.add :base, :status_to_check_correct_paid if freelance_check_complete_field_string(paid_id)
            else
              if role_frelancer? and freelance_role_check_off
                errors.add :base, :stop_change_field
                check_error_role = false
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
                    check_error_pay = false
                  elsif check_amount_pay
                    errors.add :base, :status_to_check_payment
                    check_error_status = false
                  elsif freelance_cash_accrued_under_zero? and status_payment_freelancer_empty?
                    errors.add :base, :status_to_check_correct_accrued
                  elsif freelance_cash_paid_under_zero? and status_payment_freelancer_empty?
                    errors.add :base, :status_to_check_correct_paid
                  end
                end
              end
              # параметр “Фриланс (начислено)” пустой, равен нулю или меньше нуля, система должна выдать ошибку при попытке сохранить любое из значений в поле “Фриланс статус” кроме пустого
              #settings_sunstrike_freelance_field_status
              unless status_payment_freelancer_empty?
                if check
                  if freelance_cash_accrued_empty? and payment_status_on_accrued? and check_error_status
                    errors.add :base, :status_to_check_accrued
                    check_correct = false
                  end
                  if payment_status_on_paid? and freelance_cash_paid_empty?
                    errors.add :base, :status_to_check_paid
                    check_correct = false
                  end
                  if freelance_cash_paid_under_zero? and check_correct
                    errors.add :base, :status_to_check_paid
                  end
                end
              end
              unless freelance_cash_accrued_empty?
                errors.add :base, :status_to_check_status_issue if issue_status
              end
              errors.add :base, :assigned_nil_status_on if assigned_nil? and freelance_role_on_without_assigned and check_error_pay
              errors.add :base, :stop_change_payments_details if payments_details_check_add and freelance_role_off and check_error_role
            end
          end
        end
      end
    end
  end
end