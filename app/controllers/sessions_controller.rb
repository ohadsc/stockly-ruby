class SessionsController < ApplicationController
  skip_before_action :authorize

  def new
  end

  def create
    session[:humble] ||= {}
    user = User.find_by(name: params[:name])
    if user and user.authenticate(params[:password])
      session[:humble]['user_id'] = user.id
      redirect_to stocks_path
    else
      redirect_to login_url, alert: 'Invalid user/password combination'
    end
  end

  def destroy
    session[:humble][:user_id] = nil
    redirect_to stocks_url, notice: "Logged out"
  end
end