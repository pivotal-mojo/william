require 'rails_helper'

describe Project do
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
        other_project.vms.create!(name: 'other vm', cpus: 2, memory: 2, storage: 2, operating_system: 'Linux')
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
        project.vms.create!(name: 'something', cpus: 2, memory: 3, storage: 1, operating_system: 'Linux')
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
        project.vms.create!(name: 'something', cpus: 2, memory: 3, storage: 1, operating_system: 'Windows')
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
        project.vms.create!(name: 'something', cpus: 2, memory: 1, storage: 1, operating_system: 'Linux')
        project.vms.create!(name: 'something', cpus: 2, memory: 1, storage: 1, operating_system: 'Linux')
        project.vms.create!(name: 'something', cpus: 2, memory: 1, storage: 1, operating_system: 'Windows')
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
end