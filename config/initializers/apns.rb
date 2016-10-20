# APNS.host = "gateway.push.apple.com"
APNS.host = "gateway.sandbox.push.apple.com"
# gateway.sandbox.push.apple.com is default
# Path to your development.pem file
APNS.pem = File.join(Rails.root, "development.pem")

# if your iOS App is available on the App Store, Use the production.pem
# and change the host
APNS.pem = File.join(Rails.root, "production.pem") if Rails.env.production?
