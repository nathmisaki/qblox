require 'spec_helper'

describe Qblox do
  it 'has a version number' do
    expect(Qblox::VERSION).not_to be nil
  end

  describe '.config' do
    it 'should respond to .config' do
      expect(Qblox).to respond_to(:config)
    end

    context 'setting configurations through block' do
      before do
        @acc_key = 'asdf1234'
        expect(Qblox).to receive(:fetch_account_settings)
        Qblox.config do |c|
          c.account_key = @acc_key
        end
      end

      it 'should set account_key correctly' do
        expect(Qblox.config.account_key).to eq(@acc_key)
      end
    end

    context 'setting all configurations directly' do
      before do
        @acc_key = 'asdf1234'
        expect(Qblox).to_not receive(:fetch_account_settings)
        Qblox.config do |c|
          c.account_key = @acc_key
          c.api_endpoint = 'https://api.quickblox.com'
        end
      end

      it 'should set account_key correctly' do
        expect(Qblox.config.account_key).to eq(@acc_key)
      end
    end
  end

  describe '.fetch_account_settings' do
    it 'should respond to .fetch_account_settings' do
      expect(Qblox).to respond_to(:fetch_account_settings)
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
        Qblox.fetch_account_settings
      end

      %w(account_id api_endpoint chat_endpoint turnserver_endpoint
         s3_bucket_name).each do |attr|
        it "should set #{attr} on config" do
          Qblox.fetch_account_settings
          expect(Qblox.config.send(attr)).to eq(@acc_settings[attr.to_sym])
        end
      end
    end
  end
end
