class UserLogsController < ApplicationController
  before_action :set_user_log, only: [:show]

  # GET /user_logs
  # GET /user_logs.json
  def index
    @user_logs = UserLog.fetch_data(current_user).
        paginate(page: params[:page], per_page: 15)
  end

  # GET /user_logs/1
  # GET /user_logs/1.json
  def show
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_user_log
    @user_log = current_user.user_logs.where(id: params[:id]).first
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def user_log_params
    params[:user_log]
  end
end