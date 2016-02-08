class ResetController < ApplicationController
  def create
    Vm.destroy_all

    redirect_to root_path
  end
end