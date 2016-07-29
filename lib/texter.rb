# Simple module based on the Twilio Docs to send sms
#Don't forget to write tests for this.
module Texter
  def send_sms(number, body)
    acct_sid = ENV['TWILIO_ACCT_SID']
    auth_token = ENV['TWILIO_AUTH']

    @client = Twilio::REST::Client.new acct_sid, auth_token
    # This will change, for better integration.

    from = '+15005550006'

    message = @client.account.messages.create(
      :from => from,
      :to => '+1'+ number,
      :body => body
      )
  end
end
