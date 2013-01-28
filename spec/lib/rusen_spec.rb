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

  end

end