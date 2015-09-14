require 'rusen/settings'
require 'rusen/notifier'
require 'rusen/notification'

module Rusen
  module Middleware

    class RusenRack

      def initialize(app, settings = {})
        @app = app

        if settings.is_a?(::Rusen::Settings)
          @settings = settings
        elsif settings.is_a?(Hash)
          @settings = ::Rusen::Settings.new(settings)
        end

        @notifier = ::Rusen::Notifier.new(@settings) if @settings
      end

      def call(env)
        begin
          @app.call(env)
        rescue Exception => error
          @notifier ||= Rusen.notifier
          @settings ||= Rusen.settings

          if @settings && !@settings.exclude_if.call(error)
            request = Rack::Request.new(env)
            @notifier.notify(error, request.GET.merge(request.POST), env, request.session)
          end

          raise
        end
      end

    end

  end
end
