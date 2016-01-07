class GroupsController < ApplicationController
  before_action :set_group, only: [:show, :edit, :update, :destroy]

  # GET /groups
  # GET /groups.json
  def index
    @groups = Group.all
  end

  # GET /groups/1
  # GET /groups/1.json
  def show
  end

  # GET /groups/new
  def new
    @group = Group.new
  end

  # GET /groups/1/edit
  def edit
  end

  # POST /groups
  # POST /groups.json
  def create
    respond_to do |format|
      @group = Group.new(
          name: params['group_name'],
          users: User.find_by_emails(params['user_emails'])
      )

      if @group.save!
        format.html { redirect_to @group, notice: 'Group was successfully created.' }
      else
        format.json { render json: "group_creation_failed" }
      end
    end
  end

  # PATCH/PUT /groups/1
  # PATCH/PUT /groups/1.json
  def update
    respond_to do |format|
      @group.should_update(params['user_emails'], params['group_name'])

      unless @group.is_changed?
        format.json { render json: "no_update_needed" }
      else
        @group.save! ?
            format.html { redirect_to @group, notice: 'Group was successfully updated.' } :
            format.json { render json: "group_update_failed" }
      end
    end
  end

  # DELETE /groups/1
  # DELETE /groups/1.json
  def destroy

    @group.destroy
    respond_to do |format|
      format.html { redirect_to groups_url, notice: 'Group was successfully deleted.' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_group
    @group = Group.find(params[:id])
  end

end
