class BugsController < ApplicationController
  before_action :set_bug, only: [:show, :edit, :update, :destroy]
  skip_before_action :verify_authenticity_token
  # GET /bugs
  # GET /bugs.json
  def index
    
    @project = get_project
    @bugs = @project.bugs
    authorize @bugs
  end

  # GET /bugs/1
  # GET /bugs/1.json
  def show
    @project = get_project
  end

  # GET /bugs/new
  def new
    @bug = Bug.new
    @user=current_user
    @project = get_project
    authorize @bug 
  end

  # GET /bugs/1/edit
  def edit
    @project = get_project
  end

  # POST /bugs
  # POST /bugs.json
  def create
   
    @bug =  current_user.bug_reports.new(bug_params)
    @user=current_user
    @project = get_project
    @bug.project=@project
    authorize @bug
      if @bug.save
        redirect_to projects_path,notice: " Bug was successfully added."
      else
        
    end
  end

  # PATCH/PUT /bugs/1
  # PATCH/PUT /bugs/1.json
  def update
    authorize @bug
  if @bug.update(bug_params)
        redirect_to project_bug_path,notice: " Bug was successfully updated."
      else
        redirect_to edit_project_bug_path,notice: " Bug was not updated."
      end
   
  end

  # DELETE /bugs/1
  # DELETE /bugs/1.json
  def destroy
    authorize @bug

    respond_to do |format|
      format.html { redirect_to project_bugs_url, notice: 'Bug was successfully destroyed.' }
      format.json { head :no_content }
    end
  end


  
  def bug_status_options
    bug_type = params[:bug_type]
    if(bug_type=="Feature")
      status_array=["new", "started", "completed"]
    else
      status_array=["new", "started", "resolved"]
    end
    respond_to do |format|
      format.json {
      render json: {status: status_array}}
    
  end
  end



  def change_status
   
    @bug = Bug.find(params[:bug])
    authorize @bug
    raw_parameters = { :bugs => { :status => params[:status] } }
    parameters = ActionController::Parameters.new(raw_parameters)
    parameters.require(:bugs).permit!

    if @bug.update_attributes( parameters.require(:bugs).permit!)
      redirect_to projects_path,notice: " Bug Status was successfully updated."
  end
end

   def assign_resolver

    @bug = Bug.find(params[:bug])
    authorize @bug
    if current_user.bugs << @bug
    
      redirect_to projects_path,notice: " Bug was successfully added."
    end
  end

  def remove_resolver
    @bug = Bug.find(params[:bug])
    authorize @bug
    if current_user.bugs.destroy(@bug)
      redirect_to projects_path,notice: " Bug was successfully removed."
  
      end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_bug
      @bug = Bug.find(params[:id])
    end
   def get_project
    @project = Project.find(params[:project_id]) 
  end
    # Only allow a list of trusted parameters through.
    def bug_params
      params.require(:bug).permit(:title, :deadline, :screenshot, :bug_type, :status)
    end
end
