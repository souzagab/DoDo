Rails.application.routes.default_url_options = {
  host: Rails.configuration.action_mailer.default_url_options[:host],
  port: Rails.configuration.action_mailer.default_url_options[:port],
  protocol: Rails.env.production? ? 'https' : 'http'
}
