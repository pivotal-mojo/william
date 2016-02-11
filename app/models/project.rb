class Project < ActiveRecord::Base
  belongs_to :group
  has_many :vms

  def self.funds_remaining
    joins('left outer join (SELECT project_id, sum(cpus) as used_cpus, sum(memory) as used_memory, sum(storage) as used_storage, count(id) as used_licenses FROM vms GROUP BY project_id) as in_use ON projects.id = in_use.project_id')
        .where('used_memory IS NULL OR memory_cap > used_memory').where('used_cpus IS NULL OR cpu_cap > used_cpus').where('used_storage IS NULL OR storage_cap > used_storage').where('used_licenses IS NULL OR windows_os_cap + linux_os_cap > used_licenses')

  end

  def self.out_of_funds
    joins('join (SELECT project_id, sum(cpus) as used_cpus, sum(memory) as used_memory, sum(storage) as used_storage, count(id) as used_licenses FROM vms GROUP BY project_id) as in_use ON projects.id = in_use.project_id')
        .where('memory_cap <= used_memory OR cpu_cap <= used_cpus OR storage_cap <= used_storage OR (windows_os_cap + linux_os_cap <= used_licenses)')
  end

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