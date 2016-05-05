require 'spec_helper'

describe Qblox::User do
  context 'Class' do
    subject { Qblox::User }
    describe '.find' do
      it { is_expected.to respond_to(:find) }
    end
  end
  context 'Instance' do
    subject { Qblox::User.new }

    describe '#dialogs' do
      it { is_expected.to respond_to(:dialogs) }
    end

    describe '#messages' do
      it { is_expected.to respond_to(:messages) }
    end

    describe '#send_message' do
      it { is_expected.to respond_to(:send_message) }
    end
  end
end
