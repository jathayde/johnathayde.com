# frozen_string_literal: true

class ContactMailer < ApplicationMailer
  default to: 'john@athayde.com'

  def new_message(message)
    @message = message
    mail(
      from: @message.email,
      reply_to: @message.email,
      subject: "[JohnAthayde.com] #{message.subject}"
    )
  end
end
