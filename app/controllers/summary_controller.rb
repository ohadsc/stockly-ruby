class SummaryController < ApplicationController

  require "#{Rails.root}/lib/stocks.rb"
  before_filter :init_stocks

  def index
    @selected_run = @stocks_util.selected_run
    @runs = @stocks_util.user_runs
    update_users_stocks
  end

  def overview
    update_users_stocks
    render json:{user_stocks: @user_stocks, users_roi: @users_roi, selected_run: @selected_run, runs: @runs}
  end

  def run
    run_id = params[:id]
    session[:humble]['run_id'] = run_id.to_s
    @selected_run = Run.find_by(id: run_id)
    @runs = @stocks_util.user_runs
    update_users_stocks
    render :partial => "summary_result_main", locals: {user_stocks: @user_stocks, users_roi: @users_roi, selected_run: @selected_run, runs: @runs}
  end

  private
  def update_selected_run
    @selected_run = @stocks_util._update_selected_run(@selected_run, @runs)
  end

  def update_users_stocks
    @user_stocks = Hash.new
    @users_roi = Hash.new
    @selected_run.group.users.each do |user|
      user.stocks.each do |stock|
        if stock.run_id == @selected_run.id
          @user_stocks[user] ||= Array.new
          @user_stocks[user] << stock
        end
      end
      unless @user_stocks[user].nil? || @user_stocks[user].size == 0
        @stocks_util.enrich_stock_from_yahoo(@user_stocks[user])
        if !@selected_run.pending?
          sum = 0
          @user_stocks[user].each do |stock|
            change = @selected_run.active? ? (stock.lastTradePriceOnly.to_f - stock.start_price.to_f)/stock.start_price.to_f : (stock.end_price.to_f - stock.start_price.to_f)/stock.start_price.to_f
            sum += change/5
          end
          @users_roi[user.id] = sum * 100
        end
      end
    end unless @selected_run.nil?
    @user_stocks = @user_stocks.sort_by { |user, stocks| @users_roi[user.id] }.reverse
  end

  private

  def init_stocks
    @stocks_util ||= Stocks.new(current_user, session[:humble])
  end

end
