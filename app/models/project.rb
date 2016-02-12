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

  def select_responsible_manager
    available = ['Joe Bobson', 'Mary Maryam', 'Guy Man']
    available.sort
  end

  def select_primary_contact
    available = ['Primary Person 1', 'Primary Person 2', 'That Man', 'Mr. Smith']
    available.sort
  end

  def select_cag
    available = ['CAG Bucket 1', 'CAG Bucket 2', 'CAG Bucket 3']
    available.sort
  end

  def select_network
    available = ['DHCP', 'Static IP', 'F5 Static IP']
    available.sort
  end

  def select_server_role
    available = ['Web Server', 'Application Server', 'Citrix', 'Exchange']
    available.sort
  end

  def select_support
    available = ['Support Vendor 1', 'Support Vendor 2']
    available.sort
  end

  def select_backup_type
    available = ['Backup Technology 1', 'Backup Technology 2']
    available.sort
  end

  def select_yes_no
    available = %w(Yes No)
  end

  def as_json(options={})
    super(options).merge(vms: vms.as_json(options))
  end
end