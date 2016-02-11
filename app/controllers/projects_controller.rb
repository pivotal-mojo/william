class ProjectsController < ApplicationController
  def show
    @project = Project.find(params[:id])
    @vm = @project.vms.build(flash[:vm])
  end

  def index
    @projects = current_user.group.projects.funds_remaining
  end

  def out_of_funds
    @projects = current_user.group.projects.out_of_funds
    render :index
  end
end