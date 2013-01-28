require 'spec_helper'

require 'rusen'
require 'rusen/notifiers/io_notifier'

describe Rusen::Notifiers::IONotifier do

  describe '.identification_symbol' do

    it 'returns :io' do
      Rusen::Notifiers::IONotifier.identification_symbol.should eq(:io)
    end

  end

  let(:settings) { Rusen::Settings.new }
  let(:output) { double(:output) }
  let(:notifier) { Rusen::Notifiers::IONotifier.new(settings, output) }
  let(:notification) { Rusen::Notification.new(Exception.new) }

  describe '#notify' do

    before do
      output.stub(:puts)
      notifier.stub(:print_title)
      notifier.stub(:print_hash)
    end

    context 'sections include :backtrace' do
      before do
        settings.sections += [:backtrace]
      end

      it 'prints the backtrace section title' do
        notifier.should_receive(:print_title).with('Backtrace')

        notifier.notify(notification)
      end

      it 'prints exception message' do
        output.should_receive(:puts).with(notification.exception.message)

        notifier.notify(notification)
      end

      it 'prints exception backtrace' do
        output.should_receive(:puts).with(notification.exception.backtrace)

        notifier.notify(notification)
      end

    end

    context 'sections does not include :backtrace' do
      before do
        settings.sections -= [:backtrace]
      end

      it 'does not prints the backtrace section title' do
        notifier.should_not_receive(:print_title).with('Backtrace')

        notifier.notify(notification)
      end
    end

    context 'sections include :request' do
      before do
        settings.sections += [:request]
      end

      it 'prints the request section title' do
        notifier.should_receive(:print_title).with('Request')

        notifier.notify(notification)
      end

      it 'prints request hash' do
        notifier.should_receive(:print_hash).with(notification.request)

        notifier.notify(notification)
      end

    end

    context 'sections does not include :request' do
      before do
        settings.sections -= [:request]
      end

      it 'does not prints the request section title' do
        notifier.should_not_receive(:print_title).with('Request')

        notifier.notify(notification)
      end
    end

    context 'sections include :session' do
      before do
        settings.sections += [:session]
      end

      it 'prints the session section title' do
        notifier.should_receive(:print_title).with('Session')

        notifier.notify(notification)
      end

      it 'prints session hash' do
        notifier.should_receive(:print_hash).with(notification.session)

        notifier.notify(notification)
      end

    end

    context 'sections does not include :session' do
      before do
        settings.sections -= [:session]
      end

      it 'does not prints the session section title' do
        notifier.should_not_receive(:print_title).with('Session')

        notifier.notify(notification)
      end
    end

    context 'sections include :environment' do
      before do
        settings.sections += [:environment]
      end

      it 'prints the environment section title' do
        notifier.should_receive(:print_title).with('Environment')

        notifier.notify(notification)
      end

      it 'prints environment hash' do
        notifier.should_receive(:print_hash).with(notification.environment)

        notifier.notify(notification)
      end

    end

    context 'sections does not include :environment' do
      before do
        settings.sections -= [:environment]
      end

      it 'does not prints the environment section title' do
        notifier.should_not_receive(:print_title).with('Environment')

        notifier.notify(notification)
      end
    end

  end

end