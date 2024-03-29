require 'messager'
require 'cleaner'
include Cleaner
class MessageCreator
  attr_accessor :message, :sms_record
  def initialize(params)
    cleaned_params = params_cleaner(allowed_params(params))
    @message = Message.new(cleaned_params)
  end

  def ok?
    # This is one of my favorite bits of code.  22 tests fail when this order is switched!
    save_message && send_notification
  end

  private

  def send_notification
    sender_present
    if email_match?(@message.recipient)
      mail_message
    elsif phone_match?(@message.recipient)
      send_sms
    else
      raise 'Messages cannot be sent unless there is a valid recipient'
    end
  end

  def sender_present
    raise 'Messages cannot be sent unless there is a valid sender' unless  (@message.sender_phone || @message.sender_email)
  end

  def mail_message
    MessageMailer.secure_message(@message).deliver_now
  end

  def send_sms
    @sms = Messager.new(@message)
    @message.body = @message.secure_id
    @sms_record = @sms.send_sms(@sms.number, @message.body)
  end

  def save_message
    @message.secure_id = SecureRandom.urlsafe_base64(25)
    @message.save
  end

  def allowed_params(params)
    { sender_email: params[:message][:sender],
      sender_phone: params[:message][:sender],
      recipient_email: params[:message][:recipient],
      recipient_phone: params[:message][:recipient],
      body: params[:message][:body]}
  end
end
