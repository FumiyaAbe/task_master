# config/initializers/env_runner_audit.rb
if ENV["ENV_RUNNER_AUDIT"] == "1"
  Rails.logger.info "ENV_RUNNER_START"

  Rails.logger.info "ENV_RUNNER/DB_URL? #{ENV.key?("DATABASE_URL")}"
  Rails.logger.info "ENV_RUNNER/SKEY? #{ENV.key?("SECRET_KEY_BASE")}"
  Rails.logger.info "ENV_RUNNER/CRED? #{ENV.key?("RAILS_MASTER_KEY")}"
  Rails.logger.info "ENV_RUNNER/Rails.env.production? #{Rails.env.production?}"

  Rails.logger.info "ENV_RUNNER_END"
end
