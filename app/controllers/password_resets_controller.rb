class PasswordResetsController < ApplicationController
  def show
    user = User.where(token: params[:id]).first
    if user
      @token = user.token
    else
     redirect_to expired_token_path
   end
  end

  def create
    user = User.where(token: params[:token]).first
    if user
      user.password = params[:password]
      user.generate_token
      user.save
      flash[:success] = "You can sign in now, your password has been updated"
      redirect_to sign_in_path
    else
      redirect_to expired_token_path
    end
  end

  def expired_token
  end
end