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
end