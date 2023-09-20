class ApplicationController < ActionController::Base
  before_action :set_current_request_details
  before_action :authenticate

  helper_method :user_signed_in?, :current_user, :current_session

  private

  def current_user
    Current.user
  end

  def current_session
    Current.session
  end

  def user_signed_in?
    Current.user.present?
  end

  def authenticate
    if (session_record = Session.find_by(id: cookies.signed[:session_token]))

      Current.session = session_record
    else
      redirect_to sign_in_path
    end
  end

  def set_current_request_details
    Current.user_agent = request.user_agent
    Current.ip_address = request.ip
  end
end
