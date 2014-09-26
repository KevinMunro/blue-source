# Be sure to restart your server when you modify this file.

# Your secret key is used for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!

# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.
# You can use `rake secret` to generate a secure secret key.

# Make sure your secret_key_base is kept private
# if you're sharing your code publicly.
BlueSource::Application.config.secret_key_base = ENV['BS_SECRET_TOKEN'] || '7ca768d649321698fa4c8af59eadf910b34b12c2d0275b2265e91877c63569c3506aa7d2c66e84c4587fe9682aecb4e7341263ac9d703eed10bba53254731511'
