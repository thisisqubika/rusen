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
    context 'when method transform is not defined' do
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

    context 'when method transform is defined' do
      before(:all) do
        Rusen::Notifier.class_eval do
          define_method(:transform) do |text|
            text.gsub(/a/, '*')
          end
        end
      end

      after(:all) do
        Rusen::Notifier.class_eval { remove_method(:transform) }
      end

      let(:exception) do
        begin
          raise StandardError, 'this is a sample message for a custom exception'
        rescue StandardError => e
          e
        end
      end

      let(:values) do
        {
          'first key with letter a' => 'value with letter a',
          'key with recursive value' => {
            'key1' => 'value1',
            'key2' => 'value2'
          },
          'key of array' => ['a', 'b', 'c', 'abc'],
          'key of hash array' => [
            {
              'key3' => 'value3',
              'key4' => 'value4'
            }
          ],
          'key_of_number' => 12345
        }
      end

      let(:transformed_values) do
        {
          'first key with letter a' => 'v*lue with letter *',
          'key with recursive value' => {
            'key1' => 'v*lue1',
            'key2' => 'v*lue2'
          },
          'key of array' => ['*', 'b', 'c', '*bc'],
          'key of hash array' => [
            {
              'key3' => 'v*lue3',
              'key4' => 'v*lue4'
            }
          ],
          'key_of_number' => '12345'
        }
      end

      let(:request) { values }
      let(:environment) { values }
      let(:session) { values }

      let(:notification) { double(:notification) }

      before { Rusen::Notification.stub(:new).and_return(notification) }

      it 'builds the notification' do
        exception_transformed = nil
        request_transformed = nil
        environment_transformed = nil
        session_transformed = nil

        Rusen::Notification.should_receive(:new) do |exception_temp, request_temp, environment_temp, session_temp|
          exception_transformed = exception_temp
          request_transformed = request_temp
          environment_transformed = environment_temp
          session_transformed = session_temp
        end

        notifier.notify(exception, request, environment, session)

        expect(exception_transformed.message).to eq('this is * s*mple mess*ge for * custom exception')
        expect(request_transformed).to eq(transformed_values)
        expect(environment_transformed).to eq(transformed_values)
        expect(session_transformed).to eq(transformed_values)
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
end
