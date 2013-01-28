require 'pony'
require 'erb'

module Rusen
  module Notifiers

    class EmailNotifier

      def self.identification_symbol
        :email
      end

      def initialize(settings)
        @settings = settings
      end

      def notify(notification)
        begin
          @notification = notification

          Pony.mail(email_options.merge({:body => build_body}))

        # We need to ignore all the exceptions thrown by EmailNotifier#notify.
        rescue Exception => e
          warn("Rusen: #{e.class}: #{e.message} prevented the notification email from being sent.")
          puts e.backtrace
        end
      end

      private

      def email_options
        {
          :to => @settings.exception_recipients,
          :via => :smtp,
          :charset => 'utf-8',
          :from => @settings.sender_address,
          :headers => { 'Content-Type' => 'text/html' },
          :via_options =>  @settings.smtp_settings,
          :subject => email_subject.force_encoding('UTF-8')
        }
      end

      def email_subject
        @settings.email_prefix + "#{@notification.exception.class}: #{@notification.exception.message}"
      end

      def build_body
        template_path = File.expand_path('../../templates/email_template.html.erb', __FILE__)

        template = File.open(template_path).read
        rhtml = ERB.new(template)
        rhtml.result(binding)
      end

    end

  end
end