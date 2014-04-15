class AdminsController < ApplicationController
  before_filter :require_user
  before_filter :require_admin


  def require_admin
    if !current_user.admin?
      flash[:error] = "You do not have permission to do that"
      redirect_to home_path
    end
  end
end