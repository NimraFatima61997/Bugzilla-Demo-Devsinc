class BugsController < ApplicationController
  before_action :set_bug, only: [:show, :edit, :update, :destroy]
  skip_before_action :verify_authenticity_token
 
  def index 
    @project = get_project
    @bugs = @project.bugs
    
    authorize @bugs
  end

  def show
    @project = get_project
  end

  def new
    @bug = Bug.new
    @user=current_user
    @project = get_project
    authorize @bug 
  end

  def edit
    @project = get_project
  end

  def create
    new_bug="false"
    @bugs=Bug.all
    @bug_title=Bug.new(bug_params)
    @project = get_project
    @bugs.each do |b|
      if b.title==@bug_title.title
        new_bug="true"
        redirect_to new_project_bug_path,notice: " Bug already exist"  
      end
    end

    if(new_bug=="false")
      @bug =  current_user.bug_reports.new(bug_params)
      @bug.project=get_project
      authorize @bug
      if @bug.save
        redirect_to projects_path,notice: " Bug was successfully added."    
      end
    end
  end

  def update
    authorize @bug
    if @bug.update(bug_params)
      redirect_to project_bug_path,notice: " Bug was successfully updated."
    else
      redirect_to edit_project_bug_path,notice: " Bug was not updated."
    end
  end

  def destroy
    authorize @bug
    if @bug.destroy
      redirect_to project_bugs_path, notice: 'Bug was successfully destroyed.' 
    else
      redirect_to project_bugs_path,notice: " Bug was not destoryed."
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
      redirect_to project_bugs_path,notice: " Bug Status was successfully updated."
     end
  end

   def assign_resolver
    @bug = Bug.find(params[:bug])
    authorize @bug
    if current_user.bugs << @bug
      redirect_to projects_path,notice: " Bug resolver was successfully added."
    end
  end

  def remove_resolver
    @bug = Bug.find(params[:bug])
    authorize @bug
    if current_user.bugs.destroy(@bug)
      redirect_to projects_path,notice: " Bug resolver was successfully removed."
    end
  end

  private
    def set_bug
      @bug = Bug.find(params[:id])
    end
   def get_project
    @project = Project.find(params[:project_id]) 
   end
    def bug_params
      params.require(:bug).permit(:title, :deadline, :screenshot, :bug_type, :status)
    end
end
