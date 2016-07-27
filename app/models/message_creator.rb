class MessageCreator
  #The failures are in this model. Only looking at the sms.  This suggests there's a problem with the sms(params) input.
  # There's no clear way for the program to distinguish between sms and email. It looks like the program was built for email, and is in the process of building sms functionality.
  attr_accessor :message, :sms_record

  def initialize(params)
    @message = Message.new(allowed_params(params))
  end

  def ok?
    save_message && send_notification
  end

  private

  def send_notification
    MessageMailer.secure_message(@message).deliver_now
  end

  def save_message
    @message.secure_id = SecureRandom.urlsafe_base64(25)
    @message.save
  end
# look below for the error, it doesn't look like the sms params are allowed.
# I'm going to change this to allow sender_phone and recipient phone, with no validation, and a simple repeat of the params, to see what happens.
  def allowed_params(params)
    { sender_email: params[:message][:sender],
      recipient_email: params[:message][:recipient],
      sender_phone: params[:message][:sender],
      recipient_phone: params[:message][:recipient],
      body: params[:message][:body]}
  end
end
