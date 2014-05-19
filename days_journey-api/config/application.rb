require File.expand_path('../boot', __FILE__)

# Don't Use activeRecord for mongoid.
#require 'rails/all'

require "action_controller/railtie"
require "action_mailer/railtie"
# If use active_resource, u must install ActiveResource gem.
#require "active_resource/railtie"
require "sprockets/railtie"

# If you want to use Rspec for Unit-testing , you don't need to use below sentence.
# Maybe we don't test for developing this API, I commented.
#require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env)

module DaysJourneyApi
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de
    I18n.enforce_available_locales = true
    
    config.autoload_paths += %W(#{config.root}/lib)
    config.autoload_paths += Dir["#{config.root}/lib/**/"]
  end
end
