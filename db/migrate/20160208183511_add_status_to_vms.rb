class AddStatusToVms < ActiveRecord::Migration
  def change
    add_column :vms, :status, :string, default: 'Provisioning', null: false
  end
end
