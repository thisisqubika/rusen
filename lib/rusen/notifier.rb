require 'rusen/notification'
require 'rusen/notifiers/io_notifier'
require 'rusen/notifiers/email_notifier'

module Rusen

  class Notifier

    def initialize(settings)
      @settings = settings

      @notifiers = []
      Notifiers.constants.each do |constant|
        klass = Notifiers.const_get(constant)
        if  @settings.outputs.include?(klass.identification_symbol)
          register(klass)
        end
      end
    end

    def register(notifier_class)
      @notifiers << notifier_class.new(@settings)
    end

    def notify(exception, request = nil, environment = nil, session = nil)
      begin
        notification = Notification.new(exception, request, environment, session)

        @notifiers.each do |notifier|
          notifier.notify(notification)
        end

      # We need to ignore all the exceptions thrown by the notifiers.
      rescue Exception
        ERROR("Rusen: Some or all the notifiers failed to sent the notification.")
      end
    end

  end

end