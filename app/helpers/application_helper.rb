module ApplicationHelper
  def current_user_json
    current_user.to_json(only: %i[email id])
  end
end
