require 'spec_helper'

require 'stringio'

require 'rusen'
require 'rusen/notifiers/io_notifier'

describe Rusen::Notifiers::IONotifier do

  describe '.identification_symbol' do

    it 'returns :io' do
      Rusen::Notifiers::IONotifier.identification_symbol.should eq(:io)
    end

  end

  let(:settings) { Rusen::Settings.new }
  let(:output) { StringIO.new }
  let(:notifier) { Rusen::Notifiers::IONotifier.new(settings, output) }

  let(:notification) do
    e = Exception.new
    e.set_backtrace([])

    Rusen::ExceptionContext.new(e, {:asdf => 'qwer'}, {:asdf => 'qwer'}, {:asdf => 'qwer'}, {:asdf => 'qwer'}, 'this is a message')
  end

  describe '#notify' do

    context 'sections include :backtrace' do
      before do
        settings.sections += [:backtrace]
      end

      it 'prints the backtrace section title' do
        notifier.notify(notification)

        output.rewind
        output.read.should match('Backtrace:')
      end

      it 'prints exception message' do
        notifier.notify(notification)

        output.rewind
        output.read.should match(notification.exception.message)
      end

      it 'prints exception backtrace' do
        notifier.notify(notification)

        output.rewind
        output.read.should match(notification.exception.backtrace.join($/))
      end

    end

    context 'sections does not include :backtrace' do
      before do
        settings.sections -= [:backtrace]
      end

      it 'does not prints the backtrace section title' do
        notifier.notify(notification)

        output.rewind
        output.read.should_not match('Backtrace:')
      end
    end

    context 'sections include :request' do
      before do
        settings.sections += [:request]
      end

      it 'prints the request section title' do
        notifier.notify(notification)

        output.rewind
        output.read.should match('Redacted Params:')
      end

      it 'prints request hash keys' do
        notifier.notify(notification)

        output.rewind
        output.read.should match(notification.request.keys.join('.*'))
      end

      it 'prints request hash values' do
        notifier.notify(notification)

        output.rewind
        output.read.should match(notification.request.values.join('.*'))
      end

    end

    context 'sections does not include :request' do
      before do
        settings.sections -= [:request]
      end

      it 'does not print the request section title' do
        notifier.notify(notification)

        output.rewind
        output.read.should_not match('Redacted Params:')
      end
    end

    context 'sections include :session' do
      before do
        settings.sections += [:session]
      end

      it 'prints the session section title' do
        notifier.notify(notification)

        output.rewind
        output.read.should match('Response Headers:')
      end

      it 'prints session hash keys' do
        notifier.notify(notification)

        output.rewind
        output.read.should match(notification.session.keys.join('.*'))
      end

      it 'prints session hash values' do
        notifier.notify(notification)

        output.rewind
        output.read.should match(notification.session.values.join('.*'))
      end

    end

    context 'sections does not include :session' do
      before do
        settings.sections -= [:session]
      end

      it 'does not prints the session section title' do
        notifier.notify(notification)

        output.rewind
        output.read.should_not match('Response Headers:')
      end
    end

    context 'sections include :environment' do
      before do
        settings.sections += [:environment]
      end

      it 'prints the environment section title' do
        notifier.notify(notification)

        output.rewind
        output.read.should match('Environment:')
      end

      it 'prints environment hash' do
        notifier.notify(notification)

        output.rewind
        output.read.should match('Environment:')
      end

      it 'prints environment hash keys' do
        notifier.notify(notification)

        output.rewind
        output.read.should match(notification.environment.keys.join('.*'))
      end

      it 'prints environment hash values' do
        notifier.notify(notification)

        output.rewind
        output.read.should match(notification.environment.values.join('.*'))
      end
    end

    context 'sections does not include :environment' do
      before do
        settings.sections -= [:environment]
      end

      it 'does not prints the environment section title' do
        notifier.notify(notification)

        output.rewind
        output.read.should_not match('Environment:')
      end
    end

  end

end
