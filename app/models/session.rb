class Session < ApplicationRecord
  before_create :set_request_details

  belongs_to :user

  private

  def set_request_details
    self.user_agent = Current.user_agent
    self.ip_address = Current.ip_address
  end
end
