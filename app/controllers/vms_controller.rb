class VmsController < ApplicationController
  respond_to :html, :json

  def create
    vm_request = project.vms.build(params.require(:vm).permit(:name, :cpus, :memory, :storage, :operating_system,
      :data_center,
      :description,
      :responsible_manager,
      :primary_contact,
      :cag,
      :network_type,
      :server_role,
      :support,
      :backup_type,
      :monitoring_enabled,
      :backup_encryption_enabled
    ))

    unless vm_request.valid?
      flash[:alert] = vm_request.errors.full_messages.join('<br/>')
      flash[:vm] = vm_request
      redirect_to project and return
    end
    vm_request.save
    ProvisioningJob.perform_later vm_request.id
    redirect_to vms_path, notice: 'VM request successful'
  end

  def index
    @projects = current_user.projects.includes(:vms)
    respond_with @projects
  end

  private

  def project
    @project = current_user.projects.find(params[:project_id])
  end
end