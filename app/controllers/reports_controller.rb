class ReportsController < ApplicationController
  def show
    @all_groups = Group.all
  end
end