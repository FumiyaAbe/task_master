require "digest"

class ApplicationController < ActionController::Base
  # モダンブラウザのみ許可（元の設定を維持）
  allow_browser versions: :modern

  # Basic認証（本番かつENVでONのとき）
  before_action :require_basic_auth

  private

  def require_basic_auth
    return unless Rails.env.production? &&
                  ENV.fetch("BASIC_AUTH_ENABLED", "false").to_s.strip.downcase == "true"

    return if bypass_basic_auth_path?(request.path)

    authenticate_or_request_with_http_basic("Restricted") do |u, p|
      secure_compare(u, ENV["BASIC_AUTH_USER"]) &
        secure_compare(p, ENV["BASIC_AUTH_PASS"])
    end
  end

  def bypass_basic_auth_path?(path)
    path.start_with?(
      "/up",
      "/assets", "/packs",
      "/rails/active_storage",
      "/favicon.ico",
      "/robots.txt"
    )
  end

  def secure_compare(a, b)
    ActiveSupport::SecurityUtils.secure_compare(
      ::Digest::SHA256.hexdigest(a.to_s),
      ::Digest::SHA256.hexdigest(b.to_s)
    )
  end
end
