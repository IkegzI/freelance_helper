require_dependency 'ssr_freelance'

Redmine::Plugin.register :freelance_helper do
  name 'Sunstrike Redmine Freelance plugin'
  author 'Pecherskyi Alexei'
  description 'Facilitate work with freelancers in redmine'
  version '0.0.1'
  url 'http://sunstrikestudios.com'
  author_url 'http://example.com/about'

  ON_OFF_CONST = [['Включен', 0], ['Выключен', 1]]
  settings default: {'sunstrike_freelance_plugin_status' => '0',
                     'sunstrike_freelance_auto_select' => '0',
                     'sunstrike_freelance_field_id' => '0',
                     'sunstrike_freelance_role_id' => '0',
                     'sunstrike_freelance_field_page' => '0',
                     'sunstrike_freelance_pay_field_id' => '0'}, partial: 'freelance/settings/freelance'
end
ActionDispatch::Callbacks.to_prepare do
  ContextMenusController.send(:include, SsrFreelance::Patches::ContextMenusControllerPatch)
  IssuesController.send(:include, SsrFreelance::Patches::IssuesControllerPatch)
  Issue.send(:include, SsrFreelance::Patches::IssuePatch)
  SettingsController.send :include, SsrFreelance::Patches::SettingsControllerPatch
  MyController.send :include, SsrFreelance::Patches::MyControllerPatch
  UsersController.send :include, SsrFreelance::Patches::UsersControllerPatch
end
