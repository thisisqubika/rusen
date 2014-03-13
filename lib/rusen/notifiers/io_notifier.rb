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
        @notification = notification

        begin
          @output.puts build_content.untaint
        # We need to ignore all the exceptions thrown by IONotifier#notify.
        rescue Exception => e
          warn("Rusen: #{e.class} #{e.message} prevented the io notifier from logging the error. Called from: #{caller.first}")
          puts e.backtrace
          raise e
        end
      end

      private

      def build_content
        template_path = File.expand_path('../../templates/io_template.txt.erb', __FILE__).untaint

        template = File.open(template_path).read.untaint
        rhtml = ERB.new(template)
        rhtml.result(binding)
      end

    end

  end
end
