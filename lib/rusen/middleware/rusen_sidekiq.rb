require 'rusen'
require 'sidekiq'

module Rusen
  module Middleware
    class RusenSidekiq
      include Sidekiq::Util

      def call(worker, msg, queue, &block)
        yield
      rescue => error
        Rusen.notify(error)

        raise
      end

    end
  end
end