require_relative 'base_notifier'

module Rusen
  module Notifiers

    class IONotifier < BaseNotifier

      STDOUT = $stdout

      def self.identification_symbol
        :io
      end

      def initialize(settings, output = STDOUT)
        super(settings)
        @output   = output
      end

      def notify(notification)
        @notification = notification
        @sessions     = get_sessions(@notification)

        # We need to ignore all the exceptions thrown by IONotifier#notify.
        @output.puts build_content
      rescue Exception => exception
        handle_notification_exception(exception)
      end

      private

      def build_content
        template_path = File.expand_path('../../templates/io_template.txt.erb', __FILE__)

        template = File.open(template_path).read
        rhtml = ERB.new(template, nil, '-')
        rhtml.result(binding)
      end

    end

  end
end
