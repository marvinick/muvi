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
  end

  def expired_token
  end
end