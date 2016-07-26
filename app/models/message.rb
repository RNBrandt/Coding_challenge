class Message < ActiveRecord::Base
  EMAIL_FORMAT = /\A(?:[_a-z0-9-]+)(\.[_a-z0-9-]+)*(\+[_a-z0-9-]+)?@([a-z0-9-]+)(\.[a-zA-Z0-9\-\.]+)*(\.[a-z]{2,4})\z/i
  #Error message originating from spec ln. 39 is triggered from this validation. I believe this is symptomatic of the problem, not the cause, but worth noting, and considering debugging techniques (Flash errors)
  validates :sender_email, :recipient_email, format: EMAIL_FORMAT, allow_nil: true
  validates :body, :secure_id, presence: true

  def sender
    sender_email || sender_phone
  end

  def recipient
    recipient_email || recipient_phone
  end

  def to_param
    secure_id
  end
end
