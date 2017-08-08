require File.expand_path('../boot', __FILE__)

require "action_controller/railtie"
require "sprockets/railtie"

if defined?(Bundler)
  Bundler.require(:default, Rails.env)
end

ENV["AUDIENCE"] ||= "external"

module AssetsContainer
  class Application < Rails::Application
    config.time_zone = 'Stockholm'
    config.i18n.default_locale = :en
    I18n.config.enforce_available_locales = true

    config.encoding = "utf-8"
    config.filter_parameters += [:password]
    config.autoload_paths += %w( lib/**/ )

    config.assets.enabled = true
    config.assets.version = '1.0'
    config.assets.precompile += %w(
      *.png *.jpg *.jpeg *.gif *.eot *.svg *.ttf *.woff *.map
      malmo.js
      malmo_s.js
      malmo.css
      malmo_without_jquery.js
      masthead_standalone.css
      masthead_standalone.js
      masthead_standalone_without_jquery.js
      analytics.js
      html5shiv-printshiv.js
      legacy/ie8.css
      icons.data.svg.css
      icons.data.png.css
      icons.fallback.css
      portwise.css
      mdReader.css
      mdReader.js
    )

    config.assets.paths += [
      Rails.root.join("app", "assets", "javascripts", ENV["AUDIENCE"]).to_s,
      Rails.root.join("vendor", "malmo_shared_assets", "stylesheets").to_s,
      Rails.root.join("vendor", "malmo_shared_assets", "stylesheets", "shared").to_s,
      Rails.root.join("vendor", "malmo_shared_assets", "stylesheets", "external").to_s,
      Rails.root.join("vendor", "malmo_shared_assets", "stylesheets", "internal").to_s,
      Rails.root.join("vendor", "net_publicator").to_s,
      Rails.root.join("vendor", "net_publicator", "gfx").to_s
    ]
  end
end

AssetsContainer::Application.config.secret_token = 'Not_used_in_this_app_but_required_by_rails'
AssetsContainer::Application.config.secret_key_base = 'Not_used_in_this_app_but_required_by_rails'
