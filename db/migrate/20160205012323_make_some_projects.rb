class MakeSomeProjects < ActiveRecord::Migration
  def up
    execute <<-SQL
INSERT INTO projects (name, group_id, created_at, updated_at)
VALUES ('Aardvark', (SELECT id FROM groups WHERE name = 'Alpha'), now(), now());
INSERT INTO projects (name, group_id, created_at, updated_at)
VALUES ('Antelope', (SELECT id FROM groups WHERE name = 'Alpha'), now(), now());
INSERT INTO projects (name, group_id, created_at, updated_at)
VALUES ('Goat', (SELECT id FROM groups WHERE name = 'Gamma'), now(), now());
INSERT INTO projects (name, group_id, created_at, updated_at)
VALUES ('Giraffe', (SELECT id FROM groups WHERE name = 'Gamma'), now(), now());
    SQL
  end
end
