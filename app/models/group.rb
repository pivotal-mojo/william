class Group < ActiveRecord::Base
  has_many :users
  has_many :projects
  has_many :vms, through: :projects
end