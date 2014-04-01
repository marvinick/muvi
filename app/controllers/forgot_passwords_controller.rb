class ForgotPasswordsController < ApplicationController
  def new
  end

  def create
    redirect_to forgot_password_path
  end
end