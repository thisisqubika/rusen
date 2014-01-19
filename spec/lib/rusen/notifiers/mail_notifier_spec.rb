require 'spec_helper'

require 'rusen'
require 'rusen/notifiers/mail_notifier'

Mail.defaults do
  delivery_method :test
end

describe Rusen::Notifiers::MailNotifier do

  describe '.identification_symbol' do

    it 'returns :mail' do
      Rusen::Notifiers::MailNotifier.identification_symbol.should eq(:mail)
    end

  end

  let(:settings) { Rusen::Settings.new.tap do |settings|
      settings.email_prefix = '[ERROR] '
      settings.sender_address = 'some_email@example.com'
      settings.exception_recipients = %w(dev_team@example.com test_team@example.com)
    end
  }
  let(:notifier) { Rusen::Notifiers::MailNotifier.new(settings) }
  let(:notification) { Rusen::Notification.new(Exception.new) }

  describe '#notify' do

    include Mail::Matchers

    let(:email_body) { notification.exception.class.to_s }

    before(:each) do
      Mail::TestMailer.deliveries.clear

      notifier.stub(:build_body).and_return(email_body)
    end

    subject {notifier.notify(notification)}

    it { should have_sent_email.from(settings.sender_address) }
    it { should have_sent_email.to(settings.exception_recipients) }

    it { should have_sent_email.with_subject(settings.email_prefix + "#{notification.exception.class}: #{notification.exception.message}") }

    # Can match subject or body with a regex
    # (or anything that responds_to? :match)

    it { should have_sent_email.matching_body(notification.exception.class.to_s) }

  end

end
