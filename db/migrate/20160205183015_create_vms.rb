class CreateVms < ActiveRecord::Migration
  def change
    create_table :vms do |t|
      t.integer :project_id, null: false
      t.string :name, null: false
      t.integer :cpus, null: false
      t.integer :memory, null: false
      t.integer :storage, null: false
      t.string :operating_system, null: false
    end
  end
end
