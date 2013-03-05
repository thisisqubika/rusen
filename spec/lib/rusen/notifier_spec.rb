require 'spec_helper'

require 'rusen/notifier'
require 'rusen/settings'
require 'rusen/notification'

module Rusen
  module Notifiers

    class DummyNotifier

      def self.identification_symbol
        :dummy
      end

      def initialize(settings)
      end

      def notify(notification)
      end

    end

  end
end

describe Rusen::Notifier do

  let(:settings) { Rusen::Settings.new }
  let(:notifier) { Rusen::Notifier.new(settings) }

  before do
    settings.outputs = [:dummy]
  end

  describe '#notify' do

    let(:exception) { double(:exception) }
    let(:request) { double(:request) }
    let(:environment) { double(:environment) }
    let(:session) { double(:session) }

    let(:notification) { double(:notification) }

    before { Rusen::Notification.stub(:new).and_return(notification) }

    it 'builds the notification' do
      Rusen::Notification.should_receive(:new).with(exception, request, environment, session)

      notifier.notify(exception, request, environment, session)
    end

    it 'sends the notification to every output' do
      Rusen::Notifiers::DummyNotifier.any_instance.should_receive(:notify).with(notification)

      notifier.notify(exception, request, environment, session)
    end

    context 'without request, environment, and session' do
      it 'builds the notification' do
        Rusen::Notification.should_receive(:new).with(exception, anything, anything, anything)

        notifier.notify(exception, request, environment, session)
      end

      it 'sends the notification to every output' do
        Rusen::Notifiers::DummyNotifier.any_instance.should_receive(:notify).with(notification)

        notifier.notify(exception)
      end
    end

  end

end
