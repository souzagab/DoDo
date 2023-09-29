class User < ApplicationRecord
  has_secure_password

  before_create :contest_email, if: :email_changed?
  after_update :erase_all_sessions, if: :saved_change_to_password_digest?

  has_many :email_verification_tokens, dependent: :destroy
  has_many :password_reset_tokens, dependent: :destroy
  has_many :sessions, dependent: :destroy
  has_many :registered_devices, class_name: "Device", dependent: :destroy

  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, allow_nil: true, length: { minimum: 8 }

  normalizes :email, with: ->(email) { email.strip.downcase }

  private

  def erase_all_sessions
    sessions.where.not(id: Current.session).delete_all
  end

  def contest_email
    self.verified = false
  end
end
