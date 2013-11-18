# Be sure to restart your server when you modify this file.

Biblechallenge::Application.config.session_store :cookie_store, key: '_biblechallenge_session',:domain => :all

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rails generate session_migration")
# Biblechallenge::Application.config.session_store :active_record_store
