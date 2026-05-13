# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Message, type: :model do
  let(:valid_attributes) do
    {
      name: 'Jane Sender',
      email: 'jane@example.com',
      subject: 'Hello',
      body: 'A message body'
    }
  end

  describe 'validations' do
    it 'is valid with all fields present' do
      expect(Message.new(valid_attributes)).to be_valid
    end

    %i[name email subject body].each do |field|
      it "is invalid without #{field}" do
        message = Message.new(valid_attributes.merge(field => nil))
        expect(message).not_to be_valid
        expect(message.errors[field]).to include("can't be blank")
      end
    end

    it 'rejects malformed email addresses' do
      message = Message.new(valid_attributes.merge(email: 'not-an-email'))
      expect(message).not_to be_valid
      expect(message.errors[:email]).to be_present
    end
  end

  describe '#persisted?' do
    it 'always returns false (not an ActiveRecord model)' do
      expect(Message.new(valid_attributes).persisted?).to be(false)
    end
  end
end
