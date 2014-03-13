require 'spec_helper'

require 'rusen/notifier'
require 'rusen/settings'
require 'rusen/exception_context'

module Rusen
  module Notifiers

    class DummyNotifier

      def self.identification_symbol
        :dummy
      end

      def initialize(settings)
      end

      def notify(exception_context)
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
    let(:custom_data) { double(:custom_data) }
    let(:request) { double(:request) }
    let(:environment) { double(:environment) }
    let(:session) { double(:session) }

    let(:exception_context) { double(:exception_context) }

    before { Rusen::ExceptionContext.stub(:new).and_return(exception_context) }

    it 'builds the exception_context' do
      exception.stub(:message)
      exception.stub(:class)

      Rusen::ExceptionContext.should_receive(:new).with(exception, request, environment, session, custom_data, anything)

      notifier.notify(exception, request, environment, session, custom_data)
    end

    it 'sends the exception_context to every output' do
      Rusen::Notifiers::DummyNotifier.any_instance.should_receive(:notify).with(exception_context)

      notifier.notify(exception, request, environment, session, custom_data)
    end

    context 'without request, environment, and session' do
      it 'builds the exception_context' do
        Rusen::ExceptionContext.should_receive(:new).with(exception, anything, anything, anything, anything, anything)

        notifier.notify(exception, request, environment, session, custom_data)
      end

      it 'sends the exception_context to every output' do
        Rusen::Notifiers::DummyNotifier.any_instance.should_receive(:notify).with(exception_context)

        notifier.notify(exception)
      end
    end

  end

end
