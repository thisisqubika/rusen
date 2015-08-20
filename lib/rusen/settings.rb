module Rusen

  class Settings

    attr_writer :outputs
    attr_writer :email_prefix
    attr_writer :email_via
    attr_writer :sender_address
    attr_writer :exception_recipients
    attr_writer :sections
    attr_writer :smtp_settings
    attr_writer :exclude_if

    attr_writer :filter_parameters

    attr_accessor :logger_name
    attr_accessor :log4r_config_file

    # Create a new Settings object using the given
    #   attributes.
    #
    # @param [Hash<String, Object>] attrs a hash with the
    #   options used to create a setting object.
    def initialize(attrs = {})
      (attrs || {}).each do |attr_name, value|
        method_name = "#{attr_name}=".to_sym

        self.send(method_name, value) if self.respond_to?(method_name)
      end
    end

    # Returns the configured outputs.
    #
    # Default: [:mail]
    #
    # @return [Array<Symbol>]
    def outputs
      @outputs || [:mail]
    end

    # Returns the notification email prefix.
    #
    # Default: '[Exception] '
    #
    # @return [String]
    def email_prefix
      @email_prefix || '[Exception] '
    end

    # Returns the email for email notifications.
    #
    # Default: :smtp
    #
    # @return [Symbol]
    def email_via
      @email_via || :smtp
    end

    # Returns the notification email sender.
    #
    # Default: ''
    #
    # @return [String]
    def sender_address
      @sender_address || ''
    end

    # Returns the notification email recipients.
    #
    # Default: []
    #
    # @return [Array<String>]
    def exception_recipients
      @exception_recipients || []
    end

    # Returns the configured sections.
    #
    # Default: [:backtrace, :request, :session, :environment]
    #
    # @return [Array<Symbol>]
    def sections
      @sections || [:backtrace, :request, :session, :environment]
    end

    # Returns the email smtp settings, if Rusen is included on a Rails
    #   application the smtp settings for the application is returned,
    #   otherwise an empty has is returned.
    #
    # @return [Hash<Symbol, Object>]
    def smtp_settings
      if @smtp_settings
        @smtp_settings
      else
        (defined?(Rails) && Rails.configuration.action_mailer.smtp_settings) || {}
      end
    end

    # Returns whether to send or not the notification for a exception.
    #
    # Default: lambda { |exception| false }
    #
    # @return [Block]
    def exclude_if
      @exclude_if || lambda { |exception| false }
    end

    # Returns the parameters we need to filter from being sent on
    #   the notification, this will be used to not send sensitive
    #   data to the developers credit card numbers for instance.
    #
    # @note
    #   If this is used with a rails app we use the config filter
    #   parameters from there if the filter parameters are not
    #   defined.
    #
    # @return [Array]
    def filter_parameters
      if @filter_parameters
        @filter_parameters || []
      else
        defined?(Rails) && Rails.configuration.filter_parameters
      end
    end

  end

end
