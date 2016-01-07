module ApplicationHelper

  def do_logout
    link_to(t('logout'), destroy_user_session_path, method: :delete)
  end

  def show_user
    link_to current_user.email, edit_user_registration_path
  end


end
