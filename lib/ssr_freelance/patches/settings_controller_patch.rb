require_dependency 'settings_controller'
module SsrFreelance
  module Patches
    module SettingsControllerPatch
      def self.included(base)
        base.class_eval do
          helper :ssr_freelance
          helper :ssr_freelance_pay
        end
      end
    end
  end
end
