require_relative 'common'

# проверка на роль фрилансера
def role_frelancer?
  if project
    begin
      role_user_ids = Member.where(user_id: assigned_to_id).find_by(project_id: project.id).role_ids
    rescue
      role_user_ids = []
    end
  end
  role_ids_custom = SsrFreelanceSetting.all.map { |item| item.role_id }.compact
  check = (role_user_ids.map { |item| true if role_ids_custom.include?(item) }).compact.pop || false
end

def assigned_nil?
  assigned_to.nil? ? true : false
end