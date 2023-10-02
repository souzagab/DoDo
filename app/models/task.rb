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
    if user.registered_devices.empty?
      Rails.logger.info "No registered devices for #{user.email}"
      return
    end

    user.registered_devices.each do |device|
      Rails.logger.info "Sending notification to #{device.endpoint}"
      notify!(device)
    end
  end

  def notify!(device)
    message = {
      title: "New task!",
      body: body,
      url: Rails.application.routes.url_helpers.task_url(self)
    }

    credentials =  {
        subject: "mailto:test@dododo.co",
        public_key: ENV.fetch("VAPID_PUBLIC_KEY"),
        private_key: ENV.fetch("VAPID_PRIVATE_KEY")
      }

    Webpush.payload_send(
      message: message,
      endpoint: device.endpoint,
      p256dh: device.p256dh,
      auth: device.auth,
      vapid: credentials
    )
  rescue WebPush::ExpiredSubscription => e
    Rails.logger.info "Expired subscription for #{device.endpoint}, error: #{e.inspect}"
    device.destroy
  end
end
