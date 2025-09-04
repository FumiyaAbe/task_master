# frozen_string_literal: true

class BasicAuth
  def initialize(app)
    @app = app
  end

  def call(env)
    # 本番のみ＆フラグONのときだけ有効化
    return @app.call(env) unless Rails.env.production? && ENV["BASIC_AUTH_ENABLED"] == "true"

    req = Rack::Request.new(env)

    # 例外パス（ヘルスチェック/アセット/Active Storage など）
    bypass = req.path.start_with?(
      "/up",                          # Rails標準ヘルスチェック（7.1+）
      "/assets", "/packs",            # sprockets/webpacker/propshaft系
      "/rails/active_storage",        # 画像など
      "/favicon.ico"
    )

    return @app.call(env) if bypass

    Rack::Auth::Basic.new(@app, "Restricted") do |u, p|
      secure_compare(u, ENV["BASIC_AUTH_USER"].to_s) &
        secure_compare(p, ENV["BASIC_AUTH_PASS"].to_s)
    end.call(env)
  end

  private

  # タイミング攻撃対策の比較
  def secure_compare(a, b)
    ActiveSupport::SecurityUtils.secure_compare(::Digest::SHA256.hexdigest(a),
                                                ::Digest::SHA256.hexdigest(b))
  end
end
