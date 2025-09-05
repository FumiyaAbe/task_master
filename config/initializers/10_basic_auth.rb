if Rails.env.production? && ENV.fetch("BASIC_AUTH_ENABLED", "false").to_s.strip.downcase == "true"
  require Rails.root.join("app/middleware/basic_auth")
  Rails.application.config.middleware.insert_before 0, ::BasicAuth
  puts "[Boot:init] BasicAuth middleware inserted via initializer"
else
  puts "[Boot:init] BasicAuth not inserted (env=#{Rails.env} enabled=#{ENV['BASIC_AUTH_ENABLED'].inspect})"
end
