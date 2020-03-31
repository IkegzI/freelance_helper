require_dependency 'ssr_freelance/hook/hooks'
require_dependency 'ssr_freelance/patches/my_controller_patch'
require_dependency 'ssr_freelance/patches/users_controller_patch'
require_dependency 'ssr_freelance/patches/settings_controller_patch'
require_dependency 'ssr_freelance/patches/context_menus_controller_patch'
require_dependency 'ssr_freelance/patches/issues_controller_patch'
require_dependency 'ssr_freelance/patches/issue_patch'
require_relative  '../app/controllers/ssr_freelance_controller'
require_relative '../app/helpers/ssr_freelance_pay_helper'
require_relative '../app/helpers/ssr_freelance_helper'
require_relative '../app/models/ssr_freelance_setting'

module SsrFreelance
  
end