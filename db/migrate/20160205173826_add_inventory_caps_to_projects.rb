class AddInventoryCapsToProjects < ActiveRecord::Migration
  def up
    add_column :projects, :cpu_cap, :integer, default: 0, null: false
    add_column :projects, :memory_cap, :integer, default: 0, null: false
    add_column :projects, :storage_cap, :integer, default: 0, null: false
    add_column :projects, :linux_os_cap, :integer, default: 0, null: false
    add_column :projects, :windows_os_cap, :integer, default: 0, null: false
  end
end
