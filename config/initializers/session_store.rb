app_name = "pai-chat"

Rails.application.config.session_store :cookie_store, key: "_#{app_name}_session", expire_after: 15.days
