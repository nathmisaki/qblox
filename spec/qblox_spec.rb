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
        Qblox.config do |c|
          c.account_key = @acc_key
        end
      end

      it 'should set account_key correctly' do
        expect(Qblox.config.account_key).to eq(@acc_key)
      end
    end
  end
end
