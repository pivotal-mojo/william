require 'securerandom'

class ProvisioningJob < ActiveJob::Base
  queue_as :default

  def perform(vm_id)
    vm = Vm.find(vm_id)
    sleep(SecureRandom.random_number(45) + 15)
    vm.update_attribute(:status, 'Active')
  end
end
