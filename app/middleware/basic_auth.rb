require "digest"

class BasicAuth
  BYPASS_PREFIXES = [
    "/up",                    # Rails標準ヘルスチェック
    "/assets", "/packs",      # アセット
    "/rails/active_storage",  # 画像など
    "/favicon.ico",
    "/robots.txt"
  ].freeze

  def initialize(app)
    @app = app
  end

  def call(env)
    enabled = Rails.env.production? && ENV["BASIC_AUTH_ENABLED"] == "true"

    # 無効時：ヘッダで可視化して素通し
    unless enabled
      status, headers, body = @app.call(env)
      headers["X-BasicAuth"] = "off"
      return [ status, headers, body ]
    end

    req = Rack::Request.new(env)

    # 例外パス（ヘルスチェック/アセット/Active Storage など）
    if BYPASS_PREFIXES.any? { |prefix| req.path.start_with?(prefix) }
      status, headers, body = @app.call(env)
      headers["X-BasicAuth"] = "bypass"
      return [ status, headers, body ]
    end

    # 有効時：Basic 認証を課す
    app = Rack::Auth::Basic.new(@app, "Restricted") do |u, p|
      secure_compare(u, ENV["BASIC_AUTH_USER"].to_s) &
        secure_compare(p, ENV["BASIC_AUTH_PASS"].to_s)
    end

    status, headers, body = app.call(env)
    headers["X-BasicAuth"] = "required"
    [ status, headers, body ]
  end

  private

  # タイミング攻撃対策の比較
  def secure_compare(a, b)
    ActiveSupport::SecurityUtils.secure_compare(
      ::Digest::SHA256.hexdigest(a.to_s),
      ::Digest::SHA256.hexdigest(b.to_s)
    )
  end
end
