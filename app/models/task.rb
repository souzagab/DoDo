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
      begin
        retries ||= 0
        notify!(device)
      rescue => e
        Rails.logger.error "Invalid subscription: #{e}"
        device.destroy
        retry if (retries += 1) < 5
      end
    end
  end

  def notify!(device)
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
