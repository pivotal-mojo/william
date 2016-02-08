class Project < ActiveRecord::Base
  belongs_to :group
  has_many :vms

  def cpus_remaining
    cpu_cap - vms.sum(:cpus)
  end

  def memory_remaining
    memory_cap - vms.sum(:memory)
  end

  def storage_remaining
    storage_cap - vms.sum(:storage)
  end

  def linux_os_remaining
    linux_os_cap - vms.where(operating_system: 'Linux').count
  end

  def windows_os_remaining
    windows_os_cap - vms.where(operating_system: 'Windows').count
  end

  def available_operating_systems
    available = []
    available << 'Windows' if windows_os_remaining > 0
    available << 'Linux' if linux_os_remaining > 0
    available.sort
  end

  def as_json(options={})
    super(options).merge(vms: vms.as_json(options))
  end
end