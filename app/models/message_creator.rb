require 'phone'
require 'cleaner'
include Cleaner
class MessageCreator
  attr_accessor :message, :sms_record
  def initialize(params)
    cleaned_params = params_cleaner(allowed_params(params))
    @message = Message.new(cleaned_params)
  end

  def ok?
    save_message && send_notification
  end

  private

  def send_notification
    #This will also need to change to allow for Twilio to work
    if email_match?(@message.recipient)
      MessageMailer.secure_message(@message).deliver_now
    elsif phone_match?(@message.recipient)
      @phone = Phone.new(@message)
      @message.body = @message.secure_id
      @sms_record = @phone.send_sms(@phone.number, @message.body)
    else

    end
  end

  def save_message
    @message.secure_id = SecureRandom.urlsafe_base64(25)
    @message.save
  end
# look below for the error, it doesn't look like the sms params are allowed.
# I'm going to change this to allow sender_phone and recipient phone, with no validation, and a simple repeat of the params, to see what happens.
# Now that I have the basics of a twilio sms set up.
  def allowed_params(params)
    { sender_email: params[:message][:sender],
      recipient_email: params[:message][:recipient],
      sender_phone: params[:message][:sender],
      recipient_phone: params[:message][:recipient],
      body: params[:message][:body]}
  end
end
