# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ContactMailer, type: :mailer do
  describe '#new_message' do
    let(:message) do
      Message.new(
        name: 'Jane Sender',
        email: 'jane@example.com',
        subject: 'Speaking inquiry',
        body: 'Would you speak at our conference?'
      )
    end

    let(:mail) { described_class.new_message(message) }

    it 'addresses the email to the site owner' do
      expect(mail.to).to eq(['john@athayde.com'])
    end

    it 'uses the sender email as the From address' do
      expect(mail.from).to eq(['jane@example.com'])
    end

    it 'sets Reply-To to the sender email' do
      expect(mail.reply_to).to eq(['jane@example.com'])
    end

    it 'prefixes the subject with the site name' do
      expect(mail.subject).to eq('[JohnAthayde.com] Speaking inquiry')
    end

    it 'includes the message body in the rendered email' do
      expect(mail.body.encoded).to include('Would you speak at our conference?')
    end
  end
end
