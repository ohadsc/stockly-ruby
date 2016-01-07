class RunsController < ApplicationController

  require "#{Rails.root}/lib/stocks.rb"
  before_filter :init_stocks
  before_action :set_run, only: [:show, :edit, :update, :destroy, :finalize, :activate]

  # GET /runs
  # GET /runs.json
  def index
    @runs = current_user.groups.map { |group| Run.where(group_id: group.id) }.flatten unless current_user.nil?
  end

  # GET /runs/1
  # GET /runs/1.json
  def show
  end

  # GET /runs/new
  def new
    @run = Run.new
    @groups = current_user.groups
  end

  def finalize
    @stocks_util.enrich_stock_from_yahoo(@run.stocks)
    respond_to do |format|
      if @run.finalize.save!
        format.html { redirect_to runs_path, notice: 'Run was successfully finalized.' }
        format.json { render :show, status: :created, location: @run }
      else
        format.html { redirect_to runs_path, notice: 'Something worng happened. Run was not finalized.' }
        format.json { render json: @run.errors, status: :unprocessable_entity }
      end
    end
  end


  def activate
    @stocks_util.enrich_stock_from_yahoo(@run.stocks)
    respond_to do |format|
      if @run.activate && @run.save!
        format.html { redirect_to runs_path, notice: 'Run was successfully activated.' }
        format.json { render :show, status: :created, location: @run }
      else
        format.html { redirect_to runs_path, notice: 'Run was not activated, all group members should have 5 stocks.' }
        format.json { render json: @run.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /runs/1/edit
  def edit
    @groups = Group.all
  end

  # POST /runs
  # POST /runs.json
  def create
    group = current_user.groups.where(id: params['group_id']).first
    @run = group.runs.build({name: params['run_name'], duration: 1})
    on_create
    session[:humble]['run_id'] = @run.id
  end

  # PATCH/PUT /runs/1
  # PATCH/PUT /runs/1.json
  def update
    respond_to do |format|
      if @run.update(run_params)
        format.html { redirect_to @run, notice: 'Run was successfully updated.' }
        format.json { render :show, status: :ok, location: @run }
      else
        format.html { render :edit }
        format.json { render json: @run.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /runs/1
  # DELETE /runs/1.json
  def destroy
    @run.destroy
    respond_to do |format|
      format.html { redirect_to runs_url, notice: 'Run was successfully deleted.' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_run
    @run = Run.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def run_params
    params.permit(:run_id).permit(:run_name).permit(:group_id)
  end

  def init_stocks
    @stocks_util ||= Stocks.new(current_user, session[:humble])
  end
end
