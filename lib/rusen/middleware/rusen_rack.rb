require 'rusen/settings'
require 'rusen/notifier'
require 'rusen/notification'

module Rusen
  module Middleware

    class RusenRack
      def initialize(app, settings = {})
        @app = app

        @rusen_settings = Settings.new

        @rusen_settings.outputs = settings[:outputs]
        @rusen_settings.sections = settings[:sections]
        @rusen_settings.email_prefix = settings[:email_prefix]
        @rusen_settings.sender_address = settings[:sender_address]
        @rusen_settings.exception_recipients = settings[:exception_recipients]
        @rusen_settings.smtp_settings = settings[:smtp_settings]

        @notifier = Notifier.new(@rusen_settings)
      end

      def call(env)
        begin
          @app.call(env)
        rescue Exception => error
          request = Rack::Request.new(env)

          @notifier.notify(error, request.GET.merge(request.POST), env, request.session)

          raise
        end
      end
    end

  end
end