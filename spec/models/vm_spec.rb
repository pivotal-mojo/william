require 'rails_helper'

describe Vm do
  def create_project_with_defaults(overrides={})
    double(:project, {cpus_remaining: 1, memory_remaining: 1, storage_remaining: 1, linux_os_remaining: 1, windows_os_remaining: 1}.merge(overrides))
  end

  def create_vm_with_defaults(project, overrides={})
    vm = Vm.new({name: 'Nothing really matters', cpus: 1, memory: 1, storage: 1, operating_system: 'Linux'}.merge(overrides))
    allow(vm).to receive(:project) { project }
    vm
  end

  it 'validates when requested resources are equal to that available for project for linux' do
    project = create_project_with_defaults
    vm = create_vm_with_defaults(project, operating_system: 'Linux')

    expect(vm).to be_valid
  end

  it 'validates when requested resources are equal to that available for project for windows' do
    project = create_project_with_defaults
    vm = create_vm_with_defaults(project, operating_system: 'Windows')

    expect(vm).to be_valid
  end

  it 'requires a name' do
    project = create_project_with_defaults
    vm = create_vm_with_defaults(project, name: nil)

    expect(vm).not_to be_valid
    expect(vm.errors).to have_key(:name)
  end

  it 'requires a number of cpus' do
    project = create_project_with_defaults
    vm = create_vm_with_defaults(project, cpus: nil)

    expect(vm).not_to be_valid
    expect(vm.errors).to have_key(:cpus)
  end

  it 'requires an amount of memory' do
    project = create_project_with_defaults
    vm = create_vm_with_defaults(project, memory: nil)

    expect(vm).not_to be_valid
    expect(vm.errors).to have_key(:memory)
  end

  it 'requires an amount of storage' do
    project = create_project_with_defaults
    vm = create_vm_with_defaults(project, storage: nil)

    expect(vm).not_to be_valid
    expect(vm.errors).to have_key(:storage)
  end

  it 'requires an OS' do
    project = create_project_with_defaults
    vm = create_vm_with_defaults(project, operating_system: nil)

    expect(vm).not_to be_valid
    expect(vm.errors).to have_key(:operating_system)
  end

  it 'requires the OS to be valid' do
    project = create_project_with_defaults
    vm = create_vm_with_defaults(project, operating_system: 'OS X')

    expect(vm).not_to be_valid
    expect(vm.errors).to have_key(:operating_system)
  end

  it 'requires cpu to be within available for project' do
    project = create_project_with_defaults(cpu_remaining:4)
    vm = create_vm_with_defaults(project, cpus: 5)

    expect(vm).not_to be_valid
    expect(vm.errors).to have_key(:cpus)
  end

  it 'requires memory to be within available for project' do
    project = create_project_with_defaults(memory_remaining: 3)
    vm = create_vm_with_defaults(project, memory: 4)

    expect(vm).not_to be_valid
    expect(vm.errors).to have_key(:memory)
  end

  it 'requires storage to be within available for project' do
    project = create_project_with_defaults(storage_remaining: 3)
    vm = create_vm_with_defaults(project, storage: 4)

    expect(vm).not_to be_valid
    expect(vm.errors).to have_key(:storage)
  end

  it 'requires Linux VM to have available license' do
    project = create_project_with_defaults(linux_os_remaining: 0)
    vm = create_vm_with_defaults(project, operating_system: 'Linux')

    expect(vm).not_to be_valid
    expect(vm.errors).to have_key(:operating_system)
  end

  it 'requires Windows VM to have available license' do
    project = create_project_with_defaults(windows_os_remaining: 0)
    vm = create_vm_with_defaults(project, operating_system: 'Windows')

    expect(vm).not_to be_valid
    expect(vm.errors).to have_key(:operating_system)
  end
end