class Project < ActiveRecord::Base
  belongs_to :group
  has_many :vms

  def cpus_remaining
    cpu_cap
  end

  def memory_remaining
    memory_cap
  end

  def storage_remaining
    storage_cap
  end

  def linux_os_remaining
    linux_os_cap
  end

  def windows_os_remaining
    windows_os_cap
  end

  def available_operating_systems
    available = []
    available << 'Windows' if windows_os_remaining > 0
    available << 'Linux' if linux_os_remaining > 0
    available.sort
  end
end