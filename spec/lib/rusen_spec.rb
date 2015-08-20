require 'spec_helper'

require 'rusen'

describe Rusen do

  describe '.settings' do

    it 'returns the global settings' do
      Rusen.settings.should be_instance_of(Rusen::Settings)
    end

  end

  describe '.notify' do

    let(:exception) { double(:exception) }
    let(:request) { double(:request) }
    let(:environment) { double(:environment) }
    let(:session) { double(:session) }

    it 'sends the notification' do
      Rusen::Notifier.any_instance.should_receive(:notify).with(exception, request, environment,
                                                                session)

      Rusen.notify(exception, request, environment, session)
    end

    it 'allows to omit the optional arguments without errors' do
      # Prevent output to console
      fake_stdout = StringIO.new
      $stdout = fake_stdout

      expect_any_instance_of(Rusen::Notifiers::BaseNotifier).to_not receive(:handle_notification_exception)
      expect_any_instance_of(Rusen::Notifier).to_not receive(:warn).
        with("Rusen: Some or all the notifiers failed to sent the notification.")

      Rusen.settings.outputs = [:io]
      Rusen.notify(Exception.new)

      $stdout = STDOUT
    end

  end

end
