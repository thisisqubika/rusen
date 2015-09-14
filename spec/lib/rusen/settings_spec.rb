
require 'spec_helper'

require 'rusen/notifier'
require 'rusen/settings'
require 'rusen/notification'

describe Rusen::Settings do

  describe '.initialize' do
    it 'initialize the attributes correctly if exists' do
      output = [:email]

      settings = Rusen::Settings.new({outputs: output})

      expect(settings.outputs).to eq(output)
    end
  end

end
