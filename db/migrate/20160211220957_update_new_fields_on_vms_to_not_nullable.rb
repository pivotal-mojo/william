class UpdateNewFieldsOnVmsToNotNullable < ActiveRecord::Migration
  def up
    change_column_default :vms, :data_center, nil
    change_column_default :vms, :description, nil
    change_column_default :vms, :responsible_manager, nil
    change_column_default :vms, :primary_contact, nil
    change_column_default :vms, :cag, nil
    change_column_default :vms, :network_type, nil
    change_column_default :vms, :server_role, nil
    change_column_default :vms, :support, nil
    change_column_default :vms, :backup_type, nil

    change_column_null :vms, :data_center, false
    change_column_null :vms, :description, false
    change_column_null :vms, :responsible_manager, false
    change_column_null :vms, :primary_contact, false
    change_column_null :vms, :cag, false
    change_column_null :vms, :network_type, false
    change_column_null :vms, :server_role, false
    change_column_null :vms, :support, false
    change_column_null :vms, :backup_type, false
  end
end
