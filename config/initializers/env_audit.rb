if ENV["ENV_AUDIT_ENABLED"] == "1"
  Rails.logger.info "ENV_AUDIT_START"

  # 1) 存在だけ（true/false）
  %w[DATABASE_URL RAILS_MASTER_KEY SECRET_KEY_BASE RAILS_SERVE_STATIC_FILES].each do |k|
    Rails.logger.info "ENV_AUDIT/#{k}_EXISTS=#{ENV.key?(k)}"
  end

  # 2) 値の有無は「set/nil」で表現（中身は出さない）
  %w[RAILS_ENV RACK_ENV RAILS_LOG_TO_STDOUT].each do |k|
    state = ENV[k].to_s.empty? ? "nil" : "set"
    Rails.logger.info "ENV_AUDIT/#{k}_STATE=#{state}"
  end

  Rails.logger.info "ENV_AUDIT_END"
end
