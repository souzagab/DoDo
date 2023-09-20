class PasswordsController < ApplicationController
  before_action :set_user

  def edit; end

  def update
    if current_password_invalid?
      redirect_to edit_password_path, alert: "The current password you entered is incorrect"
    elsif @user.update(user_params)
      redirect_to root_path, notice: "Your password has been changed"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_user
    @user = Current.user
  end

  def user_params
    password_params.slice(:password, :password_confirmation)
  end

  def password_params
    params.permit(:current_password, :password, :password_confirmation)
  end

  def current_password_invalid?
    !@user.authenticate(password_params[:current_password])
  end
end
