require 'erb'
require 'log4r'
require 'log4r/yamlconfigurator'

module Rusen
  module Notifiers

    class Log4rNotifier


      def self.identification_symbol
        :log4r
      end

      def initialize(settings)
        @settings = settings

        load_config(@settings.log4r_config_file.untaint)

        @logger = logger_instance(@settings.logger_name.untaint)
      end

      def notify(notification)
        @notification = notification
        begin
          @logger.error { build_content }
        # We need to ignore all the exceptions thrown by Log4rNotifier#notify.
        rescue Exception => e
          warn("Rusen: #{e.class} #{e.message} prevented the log4r notifier from logging the error. Called from: #{caller.first}")
          puts e.backtrace
        end
      end

      private

      def build_content
        template_path = File.expand_path('../../templates/log4r_template.txt.erb', __FILE__).untaint

        template = File.open(template_path).read.untaint
        rhtml = ERB.new(template)
        rhtml.result(binding)
      end

      def logger_instance(name = nil)
        if name
          Log4r::Logger[name]
        else
          Log4r::Logger.root
        end
      end

      # Loads the given config file.
      #
      # @param [String] config_yml Configuration file path.
      def load_config(config_yml)
        if config_yml
          Log4r::YamlConfigurator.load_yaml_file(config_yml)
        end
      end
    end

  end
end
