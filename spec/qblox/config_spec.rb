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

    describe '#fetch_account_settings' do
      it 'should respond to #fetch_account_settings' do
        expect(subject).to respond_to(:fetch_account_settings)
      end

      context 'fetching' do
        before do
          @acc_settings = {
            account_id: 55,
            api_endpoint: 'https://api.quickblox.com',
            chat_endpoint: 'chat.quickblox.com',
            turnserver_endpoint: 'turnserver.quickblox.com',
            s3_bucket_name: 'qbprod'
          }
          expect_any_instance_of(Qblox::Api::AccountSettings)
            .to receive(:fetch).and_return(@acc_settings)
        end

        it 'should call get on AccountSettings' do
          subject.fetch_account_settings
        end

        %w(account_id api_endpoint chat_endpoint turnserver_endpoint
         s3_bucket_name).each do |attr|
          it "should set #{attr} on config" do
            subject.fetch_account_settings
            expect(subject.send(attr)).to eq(@acc_settings[attr.to_sym])
          end
        end
      end
    end
  end
end
