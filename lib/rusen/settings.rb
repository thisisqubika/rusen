module Rusen

  class Settings

    attr_writer :outputs
    attr_writer :email_prefix
    attr_writer :sender_address
    attr_writer :exception_recipients
    attr_writer :sections
    attr_writer :smtp_settings

    def outputs
      @outputs || [:io, :email]
    end

    def email_prefix
      @email_prefix || '[Exception] '
    end

    def sender_address
      @sender_address || ''
    end

    def exception_recipients
      @exception_recipients || []
    end

    def sections
      @sections || [:backtrace, :request, :session, :environment]
    end

    def smtp_settings
      @smtp_settings || {}
    end

  end

end