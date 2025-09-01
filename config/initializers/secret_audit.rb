# config/initializers/secret_audit.rb
if ENV["SECRET_AUDIT"] == "1"
  Rails.logger.info "SECRET_AUDIT_START"

  # credentials側のsecret_key_baseが存在するか（中身は出さない）
  begin
    cred = Rails.application.credentials.secret_key_base
    cred_state = cred.present? ? "true" : "false"
  rescue => e
    cred_state = "no_credentials"
  end

  # ENVのSECRET_KEY_BASEが存在するか（中身は出さない）
  env_state = ENV.key?("SECRET_KEY_BASE")

  Rails.logger.info "SECRET_AUDIT/CREDENTIALS_SECRET_KEY_BASE? #{cred_state}"
  Rails.logger.info "SECRET_AUDIT/ENV_SECRET_KEY_BASE? #{env_state}"

  # 参考：どちら経由で解決される想定か（推論）
  source =
    if env_state
      "ENV"
    elsif cred_state == "true"
      "CREDENTIALS"
    else
      "MISSING"
    end
  Rails.logger.info "SECRET_AUDIT/RESOLVED_SOURCE #{source}"

  Rails.logger.info "SECRET_AUDIT_END"
end
