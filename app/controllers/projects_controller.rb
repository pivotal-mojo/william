class ProjectsController < ApplicationController
  def show
    @project = Project.find(params[:id])
    @vm = @project.vms.build(flash[:vm])
  end
end