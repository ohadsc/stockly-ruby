class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :update_user_log
  before_action :init_session

  rescue_from ActiveRecord::RecordNotFound, with: :error
  rescue_from Exception, with: :error
  rescue_from ActionController::RoutingError, with: :not_found

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :authenticate_user!

  def current_user
    super
  end

  protected
  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:email, :password, :password_confirmation, roles: []) }
  end

  def on_create
    entity = instance_variable_get("@#{controller_name.singularize}")
    respond_to do |format|
      if entity.save!
        format.html { redirect_to entity, notice: t('success_create') }
        format.json { render :show, status: :created, location: entity }
      else
        format.html { render :new }
        format.json { render json: entity.errors, status: :unprocessable_entity }
      end
    end
  end

  def init_session
    session[:humble] ||= {}
  end

  def raise_not_found
    raise ActionController::RoutingError.new("No route matches #{params[:unmatched_route]}")
  end

  def handle_error(e)
    logger.info e.inspect
    ErrorLog.handle_error(current_user, e)
  end

  def not_found(e)
    handle_error(e)
    respond_to do |format|
      format.html { render file: "#{Rails.root}/public/404", layout: false, status: :not_found }
      format.xml { head :not_found }
      format.any { head :not_found }
    end
  end

  def error(e)
    handle_error(e)
    respond_to do |format|
      format.html { render file: "#{Rails.root}/public/500", layout: false, status: :error }
      format.xml { head :not_found }
      format.any { head :not_found }
    end
  end

  def update_user_log
    UserLog.handle_log(request, response, controller_name, action_name, current_user)
  end

end
