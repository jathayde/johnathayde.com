# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'Devise modules' do
    it 'enables database_authenticatable' do
      expect(described_class.devise_modules).to include(:database_authenticatable)
    end

    it 'enables registerable' do
      expect(described_class.devise_modules).to include(:registerable)
    end

    it 'enables recoverable' do
      expect(described_class.devise_modules).to include(:recoverable)
    end

    it 'enables rememberable' do
      expect(described_class.devise_modules).to include(:rememberable)
    end

    it 'enables validatable' do
      expect(described_class.devise_modules).to include(:validatable)
    end
  end

  describe 'validations (via :validatable)' do
    let(:valid_password) { 'correct-horse-battery-staple' }

    it 'requires an email' do
      user = described_class.new(password: valid_password)
      expect(user).not_to be_valid
      expect(user.errors[:email]).to be_present
    end

    it 'requires the email to look like an email' do
      user = described_class.new(email: 'not-an-email', password: valid_password)
      expect(user).not_to be_valid
      expect(user.errors[:email]).to be_present
    end

    it 'rejects passwords shorter than 6 characters' do
      user = described_class.new(email: 'jane@example.com', password: 'short')
      expect(user).not_to be_valid
      expect(user.errors[:password]).to be_present
    end
  end
end
