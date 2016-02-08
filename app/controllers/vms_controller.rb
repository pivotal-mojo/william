class VmsController < ApplicationController
  def create
    vm_request = project.vms.create(params.require(:vm).permit(:name, :cpus, :memory, :storage, :operating_system))
    unless vm_request.valid?
      flash[:alert] = vm_request.errors.full_messages.join('<br/>')
      flash[:vm] = vm_request
      redirect_to project and return
    end
    redirect_to vms_path, notice: 'VM request successful'
  end

  def index
    @projects = current_user.projects.includes(:vms)
  end

  private

  def project
    @project = current_user.projects.find(params[:project_id])
  end
end