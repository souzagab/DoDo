class SessionsController < ApplicationController
  layout "blank"

  skip_before_action :authenticate, only: %i[new create]

  before_action :set_session, only: :destroy

  def index
    @sessions = Current.user.sessions.order(created_at: :desc)
  end

  def new; end

  def create # rubocop:disable Metrics/AbcSize
    if (user = User.authenticate_by(email: session_params[:email], password: session_params[:password]))

      @session = user.sessions.create!

      cookies.signed.permanent[:session_token] = { value: @session.id, httponly: true }

      redirect_to root_path, notice: "Signed in successfully"
    else
      redirect_to sign_in_path(emPail_hint: session_params[:email]), alert: "That email or password is incorrect"
    end
  end

  def destroy
    @session.destroy

    redirect_to sessions_path, notice: "That session has been logged out"
  end

  private

  def session_params
    params.permit(:email, :password)
  end

  def set_session
    @session = Current.user.sessions.find(params[:id])
  end
end
