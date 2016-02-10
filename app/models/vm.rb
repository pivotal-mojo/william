class Vm < ActiveRecord::Base
  belongs_to :project

  validates :name,    presence: true
  validates :cpus,    presence: true, :numericality => { :greater_than => 0 }
  validates :memory,  presence: true, :numericality => { :greater_than => 0 }
  validates :storage, presence: true, :numericality => { :greater_than => 0 }
  validates :operating_system, presence: true, inclusion: ['Windows', 'Linux']

  validate :cpus_under_cap
  validate :memory_under_cap
  validate :storage_under_cap
  validate :os_license_available

  private

  def cpus_under_cap
    if cpus.present? && cpus > project.cpus_remaining
      errors.add(:cpus, "#{cpus} CPUs is too many, maximum available of #{project.cpus_remaining}")
    end
  end

  def memory_under_cap
    if memory.present? && memory > project.memory_remaining
      errors.add(:memory, "#{memory}MB memory is too much, maximum available of #{project.memory_remaining}MB")
    end
  end

  def storage_under_cap
    if storage.present? && storage > project.storage_remaining
      errors.add(:storage, "#{storage}GB storage is too much, maximum available of #{project.storage_remaining}GB")
    end
  end

  def os_license_available
    unless !errors.has_key?(:operating_system) && project.public_send("#{operating_system.downcase}_os_remaining") > 0
      errors.add(:operating_system, "There are no remaining licenses for #{operating_system}")
    end
  end
end