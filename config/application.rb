require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module TaskMaster
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 8.0

    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: %w[assets tasks])

    # =========================================
    # Locale & Timezone 設定
    # =========================================
    # 東京時間を使用
    config.time_zone = "Tokyo"
    # ActiveRecord の保存時刻をローカル（開発では直感的）
    config.active_record.default_timezone = :local

    # 日本語をデフォルトに（英語も選択可能）
    config.i18n.default_locale = :ja
    config.i18n.available_locales = [ :ja, :en ]
    # 日本語訳が無い場合は英語にフォールバック
    config.i18n.fallbacks = [ :en ]


    # app/middleware を読み込み対象に
    config.autoload_paths << Rails.root.join("app/middleware")
    config.eager_load_paths << Rails.root.join("app/middleware")

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.eager_load_paths << Rails.root.join("extras")
  end
end
