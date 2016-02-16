require 'csv'

class ReportsController < ApplicationController
  respond_to :html, :csv

  def show
    @all_groups = Group.all

    respond_to do |format|
      format.html { render }
      format.csv { send_data generate_csv(@all_groups) }
    end
  end

  private

  def generate_csv(groups)
    CSV.generate(headers: ['Group Name', 'Project Name', 'VM Name', 'CPUs', 'Memory (MB)', 'Storage (GB)'], write_headers: true) do |csv|
      groups.each do |g|
        g.projects.each do |p|
          p.vms.each do |vm|
            csv << [g.name, p.name, vm.name, vm.cpus, vm.memory, vm.storage, 1]
          end
        end
      end
    end
  end
end