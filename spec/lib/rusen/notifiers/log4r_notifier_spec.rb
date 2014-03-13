require 'spec_helper'

require 'log4r'
require 'log4r/yamlconfigurator'

require 'rusen'
require 'rusen/notifiers/log4r_notifier'

describe Rusen::Notifiers::Log4rNotifier do

  describe '.identification_symbol' do

    it 'returns :log4r' do
      Rusen::Notifiers::Log4rNotifier.identification_symbol.should eq(:log4r)
    end
  end

  let(:settings) { Rusen::Settings.new }
  let(:notifier) { Rusen::Notifiers::Log4rNotifier.new(settings) }
  let(:notification) do
    e = Exception.new
    e.set_backtrace([])

    Rusen::ExceptionContext.new(e)
  end

  describe '#notify' do

    context 'when no logger specified' do
      it 'logs to root logger' do
        Log4r::Logger.root.should_receive(:error)

        notifier.notify(notification)
      end
    end

    context 'when logger specified' do
      let(:logger_name) { 'test_logger' }
      let(:io) { StringIO.new }

      let(:logger) do
        outputter = Log4r::IOOutputter.new('io', io)

        logger = Log4r::Logger.new(logger_name)
        logger.outputters = outputter

        logger
      end

      before do
        settings.logger_name = logger_name
      end

      it 'logs to it' do
        logger.should_receive(:error)

        notifier.notify(notification)
      end

      it 'logs' do
        logger.level = Log4r::ERROR

        notifier.notify(notification)

        io.rewind
        io.read.should match(/ERROR test_logger/)
      end
    end

    context 'when config file specified' do
      let(:config_file) { 'log4r.yml' }

      before do
        settings.log4r_config_file = config_file
      end

      it 'loads it' do
        Log4r::YamlConfigurator.should_receive(:load_yaml_file).with(config_file)

        notifier.notify(notification)
      end
    end

  end
end
