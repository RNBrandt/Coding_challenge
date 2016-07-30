
class Phone
  # a class to take a number and turn it into a 10 digit number string
  #Don't forget to write tests for this
  attr_reader :number
  def initialize(message_object)
    @number = message_object.recipient_phone
  end

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
