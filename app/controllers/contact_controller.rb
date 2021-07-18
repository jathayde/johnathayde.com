class ContactController < ApplicationController
  def new
    @message = Message.new
  end

  def create
    @message = Message.new(message_params)
    recaptcha_valid = verify_recaptcha(model: @message, action: 'new')
    if recaptcha_valid && @message.valid?
      ContactMailer.new_message(@message).deliver
      redirect_to(root_path, notice: "Message was successfully sent.")
    else
      flash.now.alert = "Please fill all fields."
      render :new
    end
  end

  private

  def message_params
    params.require(:message)
      .permit(
        :name,
        :email,
        :subject,
        :body
      )
  end
end
