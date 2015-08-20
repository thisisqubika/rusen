require 'erb'
require_relative '../utils/parameter_filter'

module Rusen
  module Notifiers

    # This class define all the base behaviour of all notifiers,
    #   for creating new notifiers this class should be
    #   extended.
    class BaseNotifier

      class << self

        # Symbol that represent the notifier, all subclasses must
        #   override this method to be correctly identified.
        #
        # @return [Symbol]
        def identification_symbol
          :base_notifier
        end

      end

      # Create a new instance of a Notifier.
      #
      # @param [Rusen::Setting] settings the settings that will be
      #   used to notify, depending on this configuration is where
      #   the exception will be notified.
      #
      # @return [Rusen::Notifier::BaseNotifier]
      def initialize(settings)
        @settings = settings.dup
      end

      # Given the exception returns all the sessions that will be
      #   included on the notification.
      #
      # @param [Rusen::Notification] notification information that
      #   will be notified.
      #
      # @return [Hash<String, Object>]
      def get_sessions(notification)
        result = {}

        include_session(result, notification.exception.backtrace, :backtrace)
        include_session(result, notification.request,             :request)
        include_session(result, notification.session,             :session)
        include_session(result, notification.environment,         :environment)

        result
      end

      # Some times when we try to notify exceptions an error could
      #   happen, for example if someone forgot to config the smtp
      #   settings, if that happens and an exception is raised then
      #   a warn is logged on the console saying the problem.
      #
      # @param [Exception] exception the error that was raised.
      def handle_notification_exception(exception)
        name = self.class.identification_symbol.to_s

        warn("Rusen: #{exception.message} prevented the #{name} notifier from login the error.")
      end

      private

      # @private
      def include_session(sessions, session, session_key)
        @settings.sections

        if @settings.sections.include?(session_key) && session
          session = parameter_filter.filter(session) if session_key != :backtrace

          sessions[session_key.to_s.capitalize] = session
        end
      end

      # @private
      def parameter_filter
        @parameter_filter ||= ParameterFilter.new(@settings.filter_parameters)
      end

    end

  end
end
