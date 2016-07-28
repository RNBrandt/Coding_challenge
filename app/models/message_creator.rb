require 'switcher'
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
      MessageMailer.secure_message(@message).deliver_now
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

  def change_recipient(input_params)
    if input_params[:recipient_phone] =~ @phone_format
      input_params[:recipient_email] = nil
    elsif input_params[:recipient_email] =~ @email_format
      input_params[:recipient_phone] = nil
    else
    end
    input_params
  end

  def change_sender(input_params)
    if input_params[:sender_phone] =~ @phone_format
      input_params[:sender_email] = nil
    elsif input_params[:sender_email] =~ @email_format
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
