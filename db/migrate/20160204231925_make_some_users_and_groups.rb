require 'devise'

class MakeSomeUsersAndGroups < ActiveRecord::Migration
  def up
    execute <<-SQL
INSERT INTO groups (name) VALUES ('Alpha');
INSERT INTO groups (name) VALUES ('Gamma');
INSERT INTO users (email, encrypted_password, group_id, created_at, updated_at)
 VALUES ('alpha-admin@example.com', '$2a$10$SDMpc5eAAgjYCkxY1WYErOu/lmkMBDZl7Q65VurArM2lfXXspswti', (SELECT id FROM groups WHERE name = 'Alpha'), now(), now());
INSERT INTO users (email, encrypted_password, group_id, created_at, updated_at)
 VALUES ('alpha-user@example.com', '$2a$10$SDMpc5eAAgjYCkxY1WYErOu/lmkMBDZl7Q65VurArM2lfXXspswti', (SELECT id FROM groups WHERE name = 'Alpha'), now(), now());
INSERT INTO users (email, encrypted_password, group_id, created_at, updated_at)
 VALUES ('gamma-admin@example.com', '$2a$10$SDMpc5eAAgjYCkxY1WYErOu/lmkMBDZl7Q65VurArM2lfXXspswti', (SELECT id FROM groups WHERE name = 'Gamma'), now(), now());
INSERT INTO users (email, encrypted_password, group_id, created_at, updated_at)
 VALUES ('gamma-user@example.com', '$2a$10$SDMpc5eAAgjYCkxY1WYErOu/lmkMBDZl7Q65VurArM2lfXXspswti', (SELECT id FROM groups WHERE name = 'Gamma'), now(), now());
    SQL
  end
end
