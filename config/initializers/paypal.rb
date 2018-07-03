PayPal::SDK.load("config/paypal.yml", Rails.env || 'development')
PayPal::SDK.logger = Rails.logger
