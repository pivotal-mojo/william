require 'rails_helper'

describe Project do
  def create_vm_with_defaults(project, overrides={})
    vm = project.vms.create!({name: 'Nothing really matters', cpus: 1, memory: 1, storage: 1, operating_system: 'Linux', data_center: 'DataCenter 1',
                              description: '', responsible_manager:'Manager', primary_contact: 'Contact', cag: 'Assistance Group 1', network_type: 'DHCP', server_role:'Role 1', support:'Vendor 1',
                              backup_type:'Backup Tool 1', monitoring_enabled:true, backup_encryption_enabled: true}.merge(overrides))
    allow(vm).to receive(:project) { project }
  end

  describe '#available_operating_systems' do
    it 'is windows and linux when both are available and no vms are provisioned' do
      project = Project.new(linux_os_cap: 1, windows_os_cap: 1)
      expect(project.available_operating_systems).to match_array(['Windows', 'Linux'])
    end

    it 'is linux when windows is not available and no vms are provisioned' do
      project = Project.new(linux_os_cap: 1, windows_os_cap: 0)
      expect(project.available_operating_systems).to match_array(['Linux'])
    end

    it 'is windows when linux is not available and no vms are provisioned' do
      project = Project.new(linux_os_cap: 0, windows_os_cap: 1)
      expect(project.available_operating_systems).to match_array(['Windows'])
    end

    it 'is empty when no os is available' do
      project = Project.new(linux_os_cap: 0, windows_os_cap: 0)
      expect(project.available_operating_systems).to be_empty
    end
  end

  describe 'remaining resources' do
    let(:group) { Group.create! }
    subject(:project) { group.projects.create!(name: 'TestProject', cpu_cap: 6, memory_cap: 5, storage_cap: 10, linux_os_cap: 8, windows_os_cap: 7) }

    context 'with no vms for this project' do
      before do
        other_project = group.projects.create!(name: 'Other', cpu_cap: 2, memory_cap: 2, storage_cap: 2, linux_os_cap: 2, windows_os_cap: 2)
        create_vm_with_defaults(other_project, name: 'other vm', cpus: 2, memory: 2, storage: 2, operating_system: 'Linux')
      end

      it 'is the cap values' do
        expect(project.cpus_remaining).to eq(6)
        expect(project.memory_remaining).to eq(5)
        expect(project.storage_remaining).to eq(10)
        expect(project.linux_os_remaining).to eq(8)
        expect(project.windows_os_remaining).to eq(7)
      end
    end

    context 'with a linux vm' do
      before do
        create_vm_with_defaults(project, name: 'something', cpus: 2, memory: 3, storage: 1, operating_system: 'Linux')
      end

      it 'reduces the remaining caps' do
        expect(project.cpus_remaining).to eq(4)
        expect(project.memory_remaining).to eq(2)
        expect(project.storage_remaining).to eq(9)
        expect(project.linux_os_remaining).to eq(7)
        expect(project.windows_os_remaining).to eq(7)
      end
    end

    context 'with a windows vm' do
      before do
        create_vm_with_defaults(project, name: 'something', cpus: 2, memory: 3, storage: 1, operating_system: 'Windows')
      end

      it 'reduces the remaining caps' do
        expect(project.cpus_remaining).to eq(4)
        expect(project.memory_remaining).to eq(2)
        expect(project.storage_remaining).to eq(9)
        expect(project.linux_os_remaining).to eq(8)
        expect(project.windows_os_remaining).to eq(6)
      end
    end

    context 'with multiple vms' do
      before do
        create_vm_with_defaults(project, name: 'something', cpus: 2, memory: 1, storage: 1, operating_system: 'Linux')
        create_vm_with_defaults(project, name: 'something', cpus: 2, memory: 1, storage: 1, operating_system: 'Linux')
        create_vm_with_defaults(project, name: 'something', cpus: 2, memory: 1, storage: 1, operating_system: 'Windows')
      end

      it 'reduces the remaining caps' do
        expect(project.cpus_remaining).to eq(0)
        expect(project.memory_remaining).to eq(2)
        expect(project.storage_remaining).to eq(7)
        expect(project.linux_os_remaining).to eq(6)
        expect(project.windows_os_remaining).to eq(6)
      end
    end
  end

  describe 'finding projects based on funds remaining' do
    let(:group) { Group.create! }
    let!(:out_of_memory) { group.projects.create!(name: 'out of memory', cpu_cap: 100, memory_cap: 10, storage_cap: 100, windows_os_cap: 20, linux_os_cap: 20) }
    let!(:out_of_cpus) { group.projects.create!(name: 'out of cpus', cpu_cap: 10, memory_cap: 100, storage_cap: 100, windows_os_cap: 20, linux_os_cap: 20) }
    let!(:out_of_storage) { group.projects.create!(name: 'out of storage', cpu_cap: 100, memory_cap: 100, storage_cap: 10, windows_os_cap: 20, linux_os_cap: 20) }
    let!(:out_of_windows) { group.projects.create!(name: 'out of windows', cpu_cap: 100, memory_cap: 100, storage_cap: 100, windows_os_cap: 1, linux_os_cap: 20) }
    let!(:out_of_linux) { group.projects.create!(name: 'out of linux', cpu_cap: 100, memory_cap: 100, storage_cap: 100, windows_os_cap: 20, linux_os_cap: 1) }
    let!(:out_of_oses) { group.projects.create!(name: 'out of oses', cpu_cap: 100, memory_cap: 100, storage_cap: 100, windows_os_cap: 1, linux_os_cap: 1) }
    let!(:no_vms) { group.projects.create!(name: 'no vms', cpu_cap: 1, memory_cap: 1, storage_cap: 1, windows_os_cap: 1, linux_os_cap: 1) }

    before do
      create_vm_with_defaults(out_of_memory, name: 'memory hog', cpus: 1, memory: 10, storage: 1, operating_system: 'Linux')
      create_vm_with_defaults(out_of_cpus, name: 'cpu hog', cpus: 10, memory: 1, storage: 1, operating_system: 'Linux')
      create_vm_with_defaults(out_of_storage, name: 'storage hog', cpus: 1, memory: 1, storage: 10, operating_system: 'Linux')
      create_vm_with_defaults(out_of_windows, name: 'windows hog', cpus: 1, memory: 1, storage: 1, operating_system: 'Windows')
      create_vm_with_defaults(out_of_linux, name: 'linux hog', cpus: 1, memory: 1, storage: 1, operating_system: 'Linux')
      create_vm_with_defaults(out_of_oses, name: 'windows hog', cpus: 1, memory: 1, storage: 1, operating_system: 'Windows')
      create_vm_with_defaults(out_of_oses, name: 'linux hog', cpus: 1, memory: 1, storage: 1, operating_system: 'Linux')
    end

    it '.out_of_funds contains only projects that are out of a required resource' do
      expect(group.projects.out_of_funds).to include(out_of_memory)
      expect(group.projects.out_of_funds).to include(out_of_cpus)
      expect(group.projects.out_of_funds).to include(out_of_storage)
      expect(group.projects.out_of_funds).to include(out_of_oses)
      expect(group.projects.out_of_funds).not_to include(out_of_windows)
      expect(group.projects.out_of_funds).not_to include(out_of_linux)
      expect(group.projects.out_of_funds).not_to include(no_vms)
    end

    it '.funds_remaining contains only projects that still have required resources' do
      expect(group.projects.funds_remaining).not_to include(out_of_memory)
      expect(group.projects.funds_remaining).not_to include(out_of_cpus)
      expect(group.projects.funds_remaining).not_to include(out_of_storage)
      expect(group.projects.funds_remaining).not_to include(out_of_oses)
      expect(group.projects.funds_remaining).to include(out_of_windows)
      expect(group.projects.funds_remaining).to include(out_of_linux)
      expect(group.projects.funds_remaining).to include(no_vms)
    end
  end
end