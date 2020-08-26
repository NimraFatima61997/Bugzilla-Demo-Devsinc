class ProjectsController < ApplicationController
  before_action :set_project, only: [:show, :edit, :update, :destroy]

  def index
    @user=current_user
    
    if @user.user_type=="Manager"
     
      @manager_project= Project.all
      @projects=Array.new
      
      @manager_project.each do |p|
        p.users.each do |pu|
          if pu.id==@user.id
            @projects<<p
          end
        end
      end
    elsif @user.user_type=="Developer"
      @projects = current_user.projects
    elsif @user.user_type=="QA"
      @projects = Project.all
    end 
    authorize @projects
  end


 def adduser
  @users = User.all
  @project = Project.find(params[:id])
 
 end

 def add
  @user = User.find(params[:user])
  @project = Project.find(params[:id])
 
  authorize @project
  @project.users<<@user

  redirect_to '/projects/'+@project.id.to_s+'/adduser',notice: @user.user_type + " was successfully added."
end

 def removeuser
  @project = Project.find(params[:id])
  @users=Array.new
  @project.users.each do |user|
    @users<<user   
  end
 end

 def remove
  @user = User.find(params[:user])
  @project = Project.find(params[:id])
  authorize @project
  @project.users.delete(@user)
  redirect_to '/projects/'+@project.id.to_s+'/removeuser',notice: @user.user_type + " was successfully removed."
end

  def show
  end

  # GET /projects/new
  def new
    @project = Project.new
    authorize @project
  end

  # GET /projects/1/edit
  def edit
  end

  # POST /projects
  # POST /projects.json
  def create
     @project = Project.new(project_params)
     @project.users<<current_user
     #byebug
   
     authorize @project
    respond_to do |format|
      if @project.save
        format.html { redirect_to @project, notice: 'Project was successfully created.' }
        format.json { render :show, status: :created, location: @project }
      else
        format.html { render :new }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /projects/1
  # PATCH/PUT /projects/1.json
  def update
    respond_to do |format|
      if @project.update(project_params)
        format.html { redirect_to @project, notice: 'Project was successfully updated.' }
        format.json { render :show, status: :ok, location: @project }
      else
        format.html { render :edit }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /projects/1
  # DELETE /projects/1.json
  def destroy
    @project.destroy
    respond_to do |format|
      format.html { redirect_to projects_url, notice: 'Project was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project
      @project = Project.find(params[:id])
      authorize @project
    end

    # Only allow a list of trusted parameters through.
    def project_params
      params.require(:project).permit(:title)
    end
end
