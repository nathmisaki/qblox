require 'spec_helper'

describe Qblox::Config do
  before do
    @acc_key = 'asdf123'
  end

  describe 'initialization' do
    it 'should accept attributes hash' do
      config = Qblox::Config.new account_key: @acc_key
      expect(config.account_key).to eq(@acc_key)
    end
  end

  context 'intialized' do
    subject { described_class.new(account_key: @acc_key) }

    describe '#base_api_endpoint' do
      it 'should return BASE_API_ENDPOINT value' do
        expect(subject.base_api_endpoint)
          .to eq(Qblox::Config::BASE_API_ENDPOINT)
      end
    end
  end
end
