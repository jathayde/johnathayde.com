# frozen_string_literal: true

class ContactMailer < ApplicationMailer
  default to: 'john@athayde.com'

  def new_message(message)
    @message = message
    mail(from: @message.email)
    mail(reply_to: @message.email)
    mail(subject: "[JohnAthayde.com] #{message.subject}")
  end
end
