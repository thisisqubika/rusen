module Rusen

  class Settings

    class << self
      attr_accessor :config, :notifier
    end

    attr_writer :outputs
    attr_writer :email_prefix
    attr_writer :sender_address
    attr_writer :exception_recipients
    attr_writer :sections
    attr_writer :smtp_settings
    attr_writer :exclude_if

    attr_accessor :logger_name
    attr_accessor :log4r_config_file

    # Returns the configured outputs.
    #
    # Default: []
    #
    # @return [Array<Symbol>]
    def outputs
      @outputs || []
    end

    # Returns the notification email prefix.
    #
    # Default: '[Exception] '
    #
    # @return [String]
    def email_prefix
      @email_prefix || '[Exception] '
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

    # Returns the email smtp settings.
    #
    # Default: {}
    #
    # @return [Hash<Symbol, Object>]
    def smtp_settings
      @smtp_settings || {}
    end

    # Returns whether to send or not the notification for a exception.
    #
    # Default: lambda { |exception| false }
    #
    # @return [Block]
    def exclude_if
      @exclude_if || lambda { |exception| false }
    end

  end

end

