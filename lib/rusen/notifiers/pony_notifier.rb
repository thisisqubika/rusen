require 'pony'
require_relative 'base_notifier'

module Rusen
  module Notifiers

    class PonyNotifier < BaseNotifier

      def self.identification_symbol
        :pony
      end

      def notify(notification)
        @notification = notification
        @sessions     = get_sessions(@notification)

        # We need to ignore all the exceptions thrown by PonyNotifier#notify.
        Pony.mail(email_options.merge({:body => build_body}))
      rescue Exception => exception
        handle_notification_exception(exception)
      end

      private

      def email_options
        {
          :to => @settings.exception_recipients,
          :via => @settings.email_via,
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
        rhtml = ERB.new(template, nil, '-')
        rhtml.result(binding)
      end

    end

  end

end