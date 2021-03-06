require File.expand_path('../boot', __FILE__)

#require 'rails/all'
require 'action_controller/railtie'
require 'sprockets/railtie'

require 'java'
require 'config/config-distribution'
require 'asutils'

require "rails_config_bug_workaround"

if defined?(Bundler)
  # If you precompile assets before deploying to production, use this line
  Bundler.require(*Rails.groups(:assets => %w(development test)))
  # If you want your assets lazily compiled in production, use this line
  # Bundler.require(:default, :assets, Rails.env)
end

module ArchivesSpacePublic
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Custom directories with classes and modules you want to be autoloadable.
    # config.autoload_paths += %W(#{config.root}/extras)

    config.paths["app/controllers"].concat(ASUtils.find_local_directories("public/controllers"))

    # Only load the plugins named here, in the order given (default is alphabetical).
    # :all can be used as a placeholder for all plugins not explicitly named.
    # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

    # Activate observers that should always be running.
    # config.active_record.observers = :cacher, :garbage_collector, :forum_observer

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # Load enums from forntend first
    # THIS DOESN'T WORK FOR DISTRIBUTED WAR... NEED TO SETUP LOCALE SHARING
    #config.i18n.load_path += Dir[Rails.root.join('..', 'frontend','config', 'locales', '**', '*.{rb,yml}')]

    config.i18n.default_locale = AppConfig[:locale]
    # Load the shared 'locales'
    ASUtils.find_locales_directories.map{|locales_directory| File.join(locales_directory)}.reject { |dir| !Dir.exists?(dir) }.each do |locales_directory|
      config.i18n.load_path += Dir[File.join(locales_directory, '**' , '*.{rb,yml}')]
    end

    # Override with any local locale files
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}')]

    # Allow overriding of the i18n locales via the local folder(s)
    if not ASUtils.find_local_directories.blank?
      ASUtils.find_local_directories.map{|local_dir| File.join(local_dir, 'public', 'locales')}.reject { |dir| !Dir.exists?(dir) }.each do |locales_override_directory|
        config.i18n.load_path += Dir[File.join(locales_override_directory, '**' , '*.{rb,yml}')]
      end
    end

    # config.i18n.default_locale = :de

    # Configure the default encoding used in templates for Ruby 1.9.
    config.encoding = "utf-8"

    # Configure sensitive parameters which will be filtered from the log file.
    config.filter_parameters += [:password]

    # Enable escaping HTML in JSON.
    config.active_support.escape_html_entities_in_json = true

    # Use SQL instead of Active Record's schema dumper when creating the database.
    # This is necessary if your schema can't be completely dumped by the schema dumper,
    # like if you have constraints or database-specific column types
    # config.active_record.schema_format = :sql

    # Enforce whitelist mode for mass assignment.
    # This will create an empty whitelist of attributes available for mass-assignment for all models
    # in your app. As such, your models will need to explicitly whitelist or blacklist accessible
    # parameters by using an attr_accessible or attr_protected declaration.
    # config.active_record.whitelist_attributes = true

    # Enable the asset pipeline
    config.assets.enabled = true

    # Version of your assets, change this if you want to expire all your assets
    config.assets.version = '1.0'

    config.assets.precompile += %w( *.js )

    # ArchivesSpace Configuration
    AppConfig.load_into(config)
  end


  class SessionGone < StandardError
  end


  class SessionExpired < StandardError
  end

end


# Load plugin init.rb files (if present)
ASUtils.find_local_directories('public').each do |dir|
  init_file = File.join(dir, "plugin_init.rb")
  if File.exists?(init_file)
    load init_file
  end
end
