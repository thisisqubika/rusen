require 'spec_helper'

require 'rusen'

describe Rusen do

  describe '.settings' do

    context "without configuration" do
      it 'returns nil' do
        #pending 'sets up a non-nil default' do
          Rusen.settings.should be_nil
        #end
      end
    end
    context "with configuration" do

      before(:each) do
        Rusen.configure
      end

      it 'returns an instance of Rusen::Settings' do
        Rusen.settings.should be_instance_of(Rusen::Settings)
      end
    end

  end

  describe '.notify' do

    before(:each) do
      Rusen.configure
    end

    let(:exception) { double(:exception) }
    let(:request) { double(:request) }
    let(:environment) { double(:environment) }
    let(:session) { double(:session) }
    let(:custom_data) { double(:custom_data) }
    let(:message) { "this is a silly message error" }

    it 'sends the notification' do

      Rusen::Notifier.any_instance.should_receive(:notify).with(exception, request, environment,
                                                                session, custom_data, message)

      Rusen.notify(exception, request, environment, session, custom_data, message)
    end

  end

end
