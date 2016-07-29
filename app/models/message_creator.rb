require 'phone'
require 'texter'
class MessageCreator
  #The failures are in this model. Only looking at the sms.  This suggests there's a problem with the sms(params) input.
  # There's no clear way for the program to distinguish between sms and email. It looks like the program was built for email, and is in the process of building sms functionality.
  attr_accessor :message, :sms_record
  # once the Twilio object is created it needs to be saved as an sms_record

  def initialize(params)
    @email_format = /\A(?:[_a-z0-9-]+)(\.[_a-z0-9-]+)*(\+[_a-z0-9-]+)?@([a-z0-9-]+)(\.[a-zA-Z0-9\-\.]+)*(\.[a-z]{2,4})\z/i
    @phone_format = /\A^1?[-\. ]?(\(\d{3}\)?[-\. ]?|\d{3}?[-\. ]?)?\d{3}?[-\. ]?\d{4}$\z/i
    cleaned_params = params_cleaner(allowed_params(params))
    @message = Message.new(cleaned_params)
  end

  def ok?
    save_message && send_notification
  end

  private

  def send_notification
    #This will also need to change to allow for Twilio to work
    if email_matcher(@message.recipient)
      MessageMailer.secure_message(@message).deliver_now
    elsif phone_matcher(@message.recipient)
      @phone = Phone.new(@message)
      @sms_record = @phone.send_sms(@phone.clean_number, @message.body)
    else

    end
  end

  def save_message
    @message.secure_id = SecureRandom.urlsafe_base64(25)
    @message.save
  end
  def allowed_params(params)
    { sender_email: params[:message][:sender],
      recipient_email: params[:message][:recipient],
      sender_phone: params[:message][:sender],
      recipient_phone: params[:message][:recipient],
      body: params[:message][:body]}
  end

  def phone_matcher(to_check)
    to_check =~ @phone_format
  end

  def email_matcher(to_check)
    to_check =~ @email_format
  end

  def change_recipient(input_params)
    if phone_matcher(input_params[:recipient_phone])
      input_params[:recipient_email] = nil
    elsif email_matcher(input_params[:recipient_email])
      input_params[:recipient_phone] = nil
    else
      p "enter a valid phone or email"
    end
    input_params
  end

  def change_sender(input_params)
    if phone_matcher(input_params[:sender_phone])
      input_params[:sender_email] = nil
    elsif email_matcher(input_params[:sender_email])
      input_params[:sender_phone] = nil
    else
      p 'Enter a valid phone number or email'
    end
    input_params
  end

  def params_cleaner(allowed)
    change_sender(change_recipient(allowed))
  end
end
