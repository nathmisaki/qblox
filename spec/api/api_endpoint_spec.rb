require 'spec_helper'

describe Qblox::Api::ApiEndpoint do
  describe '#connection' do
    before do
      @config = double(Qblox::Config)
    end

    context 'calling' do
      subject { described_class.new(config: @config) }

      it 'should call api_endpoint on config' do
        expect(@config).to receive(:api_endpoint)
          .and_return('https://api.quickblox.com')
        subject.connection
      end
    end
  end
end
