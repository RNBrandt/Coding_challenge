# I saved this class in the library file for the same reason I saved the 'cleaner' module, it doesn't belong in the main app folder, and I prefer the library over the helper file.
# Rather than the 'cleaner' module, there are methods that need to be instantiated, and different instances of this that may be created to deal with different recipient phone numbers.
class Messager
  attr_reader :number
  def initialize(message_object)
    @number = message_object.recipient_phone
  end

  #This method is tested in message_creator_spec 60-63
  def send_sms(number, body)
    acct_sid = ENV['TWILIO_ACCT_SID']
    auth_token = ENV['TWILIO_AUTH']

    @client = Twilio::REST::Client.new acct_sid, auth_token

    from = '+15005550006'

    message = @client.account.messages.create(
      :from => from,
      :to => '+1'+ number,
      :body => body
      )
  end
end
