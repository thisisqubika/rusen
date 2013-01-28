require 'spec_helper'

require 'rusen'
require 'rusen/notifiers/email_notifier'

describe Rusen::Notifiers::EmailNotifier do

  describe '.identification_symbol' do

    it 'returns :email' do
      Rusen::Notifiers::EmailNotifier.identification_symbol.should eq(:email)
    end

  end

  let(:settings) { Rusen::Settings.new }
  let(:notifier) { Rusen::Notifiers::EmailNotifier.new(settings) }
  let(:notification) { Rusen::Notification.new(Exception.new) }

  describe '#notify' do

    let(:email_options) { {:email_options => double(:options)} }
    let(:email_body) { double(:email_body) }

    before do
      notifier.stub(:email_options).and_return(email_options)
      notifier.stub(:build_body).and_return(email_body)
    end

    it 'sends the email with the correct options' do
      Pony.should_receive(:mail).with(hash_including(email_options))

      notifier.notify(notification)
    end

    it 'sends the email with the correct body' do
      Pony.should_receive(:mail).with(hash_including(:body => email_body))

      notifier.notify(notification)
    end

  end

end