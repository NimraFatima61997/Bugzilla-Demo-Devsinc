class ProjectsController < ApplicationController
  before_action :set_project, only: [:show, :edit, :update, :destroy]
   before_action :authenticate_user!
  def index
    @user=current_user
    
    if policy(current_user).manager?
    @projects=current_user.projects
    elsif policy(current_user).developer?
      @projects = current_user.projects
    elsif policy(current_user).qa?
      @projects = Project.all
    end 

    if @projects.empty?

    else
      authorize @projects
    end

      
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

  def new
    @project = Project.new
    authorize @project
  end

  def edit
  end

  def create
    @project=current_user.projects.create(project_params)
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

  def destroy
    @project.destroy
    respond_to do |format|
      format.html { redirect_to projects_url, notice: 'Project was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_project
      @project = Project.find(params[:id])
      authorize @project
    end

    def project_params
      params.require(:project).permit(:title)
    end
end
