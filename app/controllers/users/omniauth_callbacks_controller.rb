class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  User.omniauth_providers.each { |provider| define_method(provider) { generic_callback(provider.to_s) } }

  def generic_callback(provider)
    begin
        @user = User.from_omniauth(request.env['omniauth.auth'])

      if @user.persisted?
        #this will throw if @user is not activated
        sign_in_and_redirect @user, event: :authentication
        # set_flash_message(:notice, :success, kind: provider.capitalize) if is_navigational_format?
        logger.info "Success login: #{provider.capitalize}" if is_navigational_format?
      else
        session["devise.#{provider}_data"] = request.env['omniauth.auth']
        redirect_to new_user_registration_url
      end
    rescue => e
      handle_error(e)
      redirect_to root_url
    end
  end

  def failure
    super
  end

end