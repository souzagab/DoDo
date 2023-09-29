class Task < ApplicationRecord
  default_scope { where(user: Current.user) }

  broadcasts_to ->(_task) { :tasks }, inserts_by: :prepend

  after_create :send_notification

  belongs_to :user

  validates :body, presence: true
  validates :due_date, comparison: { greater_than_or_equal_to: -> { Time.zone.today }, allow_nil: true }

  enum status: { open: "open", closed: "closed", archived: "archived" }

  def self.search(params)
    params["q"].nil? ? all : where("body LIKE ?", "%#{sanitize_sql_like(params[:q])}%")
  end

  private

  def send_notification
    return if user.registered_devices.empty?

    device = user.registered_devices.last

    Webpush.payload_send(
      message: "New task: #{body}",
      endpoint: device.endpoint,
      p256dh: device.p256dh,
      auth: device.auth,
      vapid: {
        subject: "mailto:test@dododo.do",
        public_key: ENV.fetch("VAPID_PUBLIC_KEY"),
        private_key: ENV.fetch("VAPID_PRIVATE_KEY")
      }
    )
  end
end
