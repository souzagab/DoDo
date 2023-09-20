class Session < ApplicationRecord
  before_create :set_request_details

  belongs_to :user

  private

  def set_request_details
    Current.user_agent = Current.user_agent
    Current.ip_address = Current.ip_address
  end
end
