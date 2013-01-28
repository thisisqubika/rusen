module Rusen
  module Notifiers

    class IONotifier

      STDOUT = $stdout

      def self.identification_symbol
        :io
      end

      def initialize(settings, output = STDOUT)
        @settings = settings
        @output = output
      end

      def notify(notification)
        begin
          if @settings.sections.include?(:backtrace)

            print_title('Backtrace')

            @output.puts notification.exception.message
            @output.puts notification.exception.backtrace
          end

          if @settings.sections.include?(:request)
            print_title('Request')

            print_hash(notification.request)
          end

          if @settings.sections.include?(:session)
            print_title('Session')

            print_hash(notification.session)
          end

          if @settings.sections.include?(:environment)
            print_title('Environment')

            print_hash(notification.environment)
          end

        # We need to ignore all the exceptions thrown by IONotifier#notify.
        rescue Exception => e
          warn("Rusen: #{e.message} prevented the io notifier from login the error.")
        end
      end

      private

      def print_title(title)
        @output.puts '-------------------------------'
        @output.puts "#{title}:"
        @output.puts '-------------------------------'
      end

      def print_hash(hash)
        hash.each.each do |k, v|
          @output.puts "#{k}\t\t\t#{v}"
        end
      end
    end

  end
end