class Device < ApplicationRecord
  belongs_to :user

  encrypts :endpoint, deterministic: true
  encrypts :p256dh
  encrypts :auth

  def keys=(keys)
    self.p256dh = keys[:p256dh]
    self.auth = keys[:auth]
  end
end
