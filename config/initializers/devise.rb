# Use this hook to configure devise mailer, warden hooks and so forth.
# Many of these configuration options can be set straight in your model.
Devise.setup do |config|

  #Replace example.com with your own domain name
  config.mailer_sender = 'teamco@gmail.com'

  require 'devise/orm/active_record'
  config.case_insensitive_keys = [:email]
  config.strip_whitespace_keys = [:email]
  config.skip_session_storage = [:http_auth]
  config.stretches = Rails.env.test? ? 1 : 10
  config.reconfirmable = true
  config.expire_all_remember_me_on_sign_out = true
  config.password_length = 8..128
  config.reset_password_within = 6.hours
  config.sign_out_via = :delete
  config.secret_key = 'd75ea36b070d78663a9f82f9170f78c0901b942788b46e0976f9d49b7405723e78af190abc4bb14cc1edada13cb60deb0d11898cb18dc8a55ccb10f76e01ad75'

#Add your ID and secret here
#ID first, secret second
# config.omniauth :digitalocean, ENV['DIGITALOCEAN_KEY'], ENV['DIGITALOCEAN_SECRET']
# config.omniauth :google, ENV['GOOGLE_KEY'], ENV['GOOGLE_SECRET']
# config.omniauth :amazon, ENV['AMAZON_KEY'], ENV['AMAZON_SECRET']
  config.omniauth :github,
                  ENV['GITHUB_KEY'],
                  ENV['GITHUB_SECRET']

  config.omniauth :aliexpress,
                  ENV['ALIEXPRESS_KEY'],
                  ENV['ALIEXPRESS_SECRET']

  config.omniauth :linkedin,
                  ENV['LINKEDIN_KEY'],
                  ENV['LINKEDIN_SECRET'],
                  scope: 'r_basicprofile r_emailaddress'

  config.omniauth :twitter,
                  ENV['TWITTER_KEY'],
                  ENV['TWITTER_SECRET'], {
                      secure_image_url: 'true',
                      image_size: 'original',
                      authorize_params: {
                          force_login: 'true',
                          lang: 'en'
                      }
                  }
  config.omniauth :facebook,
                  "1028051820552940",
                  "97d6d9ae1df069ed6e9fcf8aa5323711", {
                      scope: 'email, public_profile',
                      client_options: {
                          site: 'https://graph.facebook.com/v2.0',
                          authorize_url: "https://www.facebook.com/v2.0/dialog/oauth"
                      },
                      info_fields: 'email'
                  }
end

