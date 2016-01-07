class StocksController < ApplicationController

  require "#{Rails.root}/lib/stocks.rb"

  before_filter :init_stocks
  before_action :set_stock, only: [:show, :edit, :update, :destroy]
  #before_action :set_runs, only: [:index, :run]
  before_action :set_new_runs, only: [:new]
  #before_action :update_selected_run, only: [:index, :run, :new]

  # GET /stocks
  # GET /stocks.json
  def index
    @runs = @stocks_util.user_runs
    @selected_run = @stocks_util.selected_run
    set_stocks
    @stocks_util.enrich_stock_from_yahoo(@stocks) if @stocks.size != 0
  end

  def run
    run_id = params[:id]
    session[:humble]['run_id'] = run_id
    @selected_run = Run.find_by(id: run_id)
    @runs = @stocks_util.user_runs
    set_stocks
    @stocks_util.enrich_stock_from_yahoo(@stocks) if @stocks.size != 0
    render :partial => "stocks_result_main", locals:  {runs: @runs, selected_run: @selected_run, stocks: @stocks}
  end

  # GET /stocks/1
  # GET /stocks/1.json
  def show
  end

  # GET /stocks/new
  def new
    @selected_run = @stocks_util.selected_run
    @stock = Stock.new
  end

  # GET /stocks/1/edit
  def edit
  end

  # POST /stocks
  # POST /stocks.json
  def create
    symbol = params[:symbol].upcase
    is_existing_stock = current_user.stocks.where(symbol: symbol, run_id: params[:run_id]).flatten.size > 0
    num_of_stocks = current_user.stocks.where( run_id: params[:run_id]).flatten.size
    respond_to do |format|
      if !is_existing_stock && num_of_stocks != 5 && @stocks_util.validate_stock(symbol)
        @stock = current_user.stocks.build({symbol:symbol, run_id: params[:run_id]})
        @stock.save!
        format.json { render json: "stock_added" }
      else
        error_msg = "adding_stock_failed"
        if num_of_stocks == 5
          error_msg = "already_5_stocks"
        elsif is_existing_stock
          error_msg = "existing_stock"
        end
        format.json { render json: error_msg }
      end
    end
  end

  # PATCH/PUT /stocks/1
  # PATCH/PUT /stocks/1.json
  def update
    respond_to do |format|
      if @stock.update(stock_params)
        format.html { redirect_to @stock, notice: 'Stock was successfully updated.' }
        format.json { render :show, status: :ok, location: @stock }
      else
        format.html { render :edit }
        format.json { render json: @stock.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /stocks/1
  # DELETE /stocks/1.json
  def destroy
    @stock.destroy
    respond_to do |format|
      format.html { redirect_to stocks_url, notice: 'Stock was successfully deleted.' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_stock
    @stock = Stock.find(params[:id])
  end

  def set_stocks
    @stocks = @selected_run.nil? ?
        current_user.stocks :
        current_user.stocks.where(run_id: @selected_run.id).flatten
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def stock_params
    params[:stock]
  end

  def set_new_runs
    @runs = current_user.groups.map { |group| group.runs.select { |run| run.status == 'pending' } }.flatten unless current_user.nil?
  end

  def init_stocks
    @stocks_util ||= Stocks.new(current_user, session[:humble])
  end


end
