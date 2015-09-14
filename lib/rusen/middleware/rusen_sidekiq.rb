require 'rusen'
require 'sidekiq'

module Rusen
  module Middleware

    # Intersect exceptions that happens on inside
    #   sidekiq workers. If an exception occurred
    #   on a worker Rusen will notify about that
    #   exception and will raised up.
    class RusenSidekiq
      include Sidekiq::Util

      # Just yield the block and rescue from any
      #   exception that occurred on the call to
      #   the worker, and notify about that
      #   exception.
      #
      # @raise [Exception] if an exception occurred
      #   that exception was notified and raised
      #   again to allow the retry to happen.
      def call(_, _, _, &block)
        yield
      rescue => error
        Rusen.notify(error)

        raise
      end

    end
  end
end
