require 'spec_helper'

describe Qblox::Api::Connections::Base do
  before do
    @config = double(Qblox::Config)
  end
  subject { described_class.new }

  describe 'initialization' do
    it 'should permit to receive new with no config' do
      expect { described_class.new }.to_not raise_error
    end

    it 'should permit to receive new optional config' do
      expect { described_class.new(config: @config) }.to_not raise_error
    end
  end

  describe '#connection' do
    it 'should respond to connection' do
      expect(subject).to respond_to(:connection)
    end

    context 'calling' do
      subject { described_class.new(config: @config) }

      it 'should call base_api_endpoint config' do
        expect(@config).to receive(:base_api_endpoint)
          .and_return('https://api.quickblox.com')
        subject.connection
      end
    end
  end

  describe '#url' do
    it 'should concatenate path and format' do
      expect(subject.url).to eq('/.json')
    end
  end
end
