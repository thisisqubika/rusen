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
          @output.puts build_content
        # We need to ignore all the exceptions thrown by IONotifier#notify.
        rescue Exception => e
          warn("Rusen: #{e.message} prevented the io notifier from login the error.")
        end
      end

      private

      def build_content
        template_path = File.expand_path('../../templates/io_template.txt.erb', __FILE__)

        template = File.open(template_path).read
        rhtml = ERB.new(template)
        rhtml.result(binding)
      end

    end

  end
end