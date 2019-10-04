require 'rusen/notifiers'
require 'rusen/notification'

module Rusen

  class Notifier

    def initialize(settings)
      @settings = settings

      @notifiers = []
      @settings.outputs.each do |ident|
        ident = Notifiers.check_deprecation(ident)
        # For notifiers bundled in this gem
        klass = Notifiers.load_klass(ident)
        if klass.nil?
          Notifiers.constants.each do |constant|
            klass = Notifiers.const_get(constant)
            next unless klass.is_a?(Class)
            break if ident == klass.identification_symbol
            klass = nil
          end
        end
        raise "Unable to load Output Notifier identified by: #{ident}" if klass.nil? || !klass.is_a?(Class)
        register(klass)
      end
    end

    def register(notifier_class)
      @notifiers << notifier_class.new(@settings)
    end

    # Sends a notification to the configured outputs.
    #
    # @param [Exception] exception The error.
    # @param [Hash<Object, Object>] request The request params
    # @param [Hash<Object, Object>] environment The environment status.
    # @param [Hash<Object, Object>] session The session status.
    def notify(exception, request = {}, environment = {}, session = {})
      begin

        notification = nil
        if respond_to?(:transform)
          transformed_exception = transform_exception(exception)
          transformed_request = transform_enumerable(request)
          transformed_environment = transform_enumerable(environment)
          transformed_session = transform_enumerable(session)
          notification = Notification.new(transformed_exception, transformed_request, transformed_environment, transformed_session)
        else
          notification = Notification.new(exception, request, environment, session)
        end

        @notifiers.each do |notifier|
          notifier.notify(notification)
        end

      # We need to ignore all the exceptions thrown by the notifiers.
      rescue Exception
        warn('Rusen: Some or all the notifiers failed to sent the notification.')
      end
    end

    # Transform an exception of type StandardError
    def transform_exception(exception)
      duplicate = exception.clone
      filtered_message = transform(duplicate.message)
      duplicate.message.replace(filtered_message)
      duplicate.backtrace.map! { |line| transform(line) }
      duplicate
    end

    # Recursive function that transform hashes, arrays and any object that can be translated to a string like integers
    def transform_enumerable(value)
      if value.is_a? Hash
        value.each { |k, e| value[k] = transform_enumerable(e) }
      elsif value.is_a? Array
        value.map { |e| transform_enumerable(e) }
      else
        transform(value.to_s)
      end
    end
  end
end
