class AddAdditionalFieldsToVms < ActiveRecord::Migration
  def change
      add_column :vms, :data_center, :string, default: 'DataCenter 1'
      add_column :vms, :description, :string, default: ''
      add_column :vms, :responsible_manager, :string, default: 'Manager'
      add_column :vms, :primary_contact, :string, default: 'Contact'
      add_column :vms, :cag, :string, default: 'Assistance Group 1'
      add_column :vms, :network_type, :string, default: 'DHCP'
      add_column :vms, :server_role, :string, default: 'Role 1'
      add_column :vms, :support, :string, default: 'Vendor 1'
      add_column :vms, :backup_type, :string, default: 'Backup Tool 1'
      add_column :vms, :monitoring_enabled, :binary, default: true, null: false
      add_column :vms, :backup_encryption_enabled, :binary, default: true, null: false
  end
end
