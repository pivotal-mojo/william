class MakeTheProjectsWrap < ActiveRecord::Migration
  def up
    execute <<-SQL
INSERT INTO projects (name, group_id, created_at, updated_at, cpu_cap, memory_cap, storage_cap, linux_os_cap, windows_os_cap)
VALUES ('Agenda', (SELECT id FROM groups WHERE name = 'Alpha'), now(), now(), 20, 40000, 40000, 5, 5);
INSERT INTO projects (name, group_id, created_at, updated_at, cpu_cap, memory_cap, storage_cap, linux_os_cap, windows_os_cap)
VALUES ('Applesauce', (SELECT id FROM groups WHERE name = 'Alpha'), now(), now(), 20, 40000, 40000, 5, 5);
INSERT INTO projects (name, group_id, created_at, updated_at, cpu_cap, memory_cap, storage_cap, linux_os_cap, windows_os_cap)
VALUES ('Apache', (SELECT id FROM groups WHERE name = 'Alpha'), now(), now(), 20, 40000, 40000, 5, 5);
INSERT INTO projects (name, group_id, created_at, updated_at, cpu_cap, memory_cap, storage_cap, linux_os_cap, windows_os_cap)
VALUES ('Application', (SELECT id FROM groups WHERE name = 'Alpha'), now(), now(), 20, 40000, 40000, 5, 5);
INSERT INTO projects (name, group_id, created_at, updated_at, cpu_cap, memory_cap, storage_cap, linux_os_cap, windows_os_cap)
VALUES ('Aggregate', (SELECT id FROM groups WHERE name = 'Alpha'), now(), now(), 20, 40000, 40000, 5, 5);

INSERT INTO projects (name, group_id, created_at, updated_at, cpu_cap, memory_cap, storage_cap, linux_os_cap, windows_os_cap)
VALUES ('Gorilla', (SELECT id FROM groups WHERE name = 'Gamma'), now(), now(), 20, 40000, 40000, 5, 5);
INSERT INTO projects (name, group_id, created_at, updated_at, cpu_cap, memory_cap, storage_cap, linux_os_cap, windows_os_cap)
VALUES ('Gigantic', (SELECT id FROM groups WHERE name = 'Gamma'), now(), now(), 20, 40000, 40000, 5, 5);
INSERT INTO projects (name, group_id, created_at, updated_at, cpu_cap, memory_cap, storage_cap, linux_os_cap, windows_os_cap)
VALUES ('Griffon', (SELECT id FROM groups WHERE name = 'Gamma'), now(), now(), 20, 40000, 40000, 5, 5);
INSERT INTO projects (name, group_id, created_at, updated_at, cpu_cap, memory_cap, storage_cap, linux_os_cap, windows_os_cap)
VALUES ('Galaxy', (SELECT id FROM groups WHERE name = 'Gamma'), now(), now(), 20, 40000, 40000, 5, 5);
INSERT INTO projects (name, group_id, created_at, updated_at, cpu_cap, memory_cap, storage_cap, linux_os_cap, windows_os_cap)
VALUES ('Gallant', (SELECT id FROM groups WHERE name = 'Gamma'), now(), now(), 20, 40000, 40000, 5, 5);
    SQL
  end

  def down
    execute <<-SQL
DELETE FROM projects WHERE name in ('Agenda', 'Applesauce', 'Apache', 'Application', 'Aggregate', 'Gorilla', 'Gigantic', 'Griffon', 'Galaxy', 'Gallant');
    SQL
  end
end
