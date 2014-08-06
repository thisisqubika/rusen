require 'erb'
require_relative '../utils/parameter_filter'

module Rusen
  module Notifiers

    class BaseNotifier

      def self.identification_symbol
        :base_notifier
      end

      def initialize(settings)
        @settings = settings.dup
      end

      def get_sessions(notification)
        result = {}

        include_session(result, notification.exception.backtrace, :backtrace)
        include_session(result, notification.request,             :request)
        include_session(result, notification.session,             :session)
        include_session(result, notification.environment,         :environment)

        result
      end

      def handle_notification_exception(exception)
        name = self.class.identification_symbol.to_s

        warn("Rusen: #{exception.message} prevented the #{name} notifier from login the error.")
      end

      private

      def include_session(sessions, session, session_key)
        @settings.sections

        if @settings.sections.include?(session_key) && session
          session = parameter_filter.filter(session) if session_key != :backtrace

          sessions[session_key.to_s.capitalize] = session
        end
      end

      def parameter_filter
        @parameter_filter ||= ParameterFilter.new(@settings.filter_parameters)
      end

    end

  end
end