class Message < ActiveRecord::Base
  EMAIL_FORMAT = /\A(?:[_a-z0-9-]+)(\.[_a-z0-9-]+)*(\+[_a-z0-9-]+)?@([a-z0-9-]+)(\.[a-zA-Z0-9\-\.]+)*(\.[a-z]{2,4})\z/i
  PHONE_FORMAT = /\A^1?[-\. ]?(\(\d{3}\)?[-\. ]?|\d{3}?[-\. ]?)?\d{3}?[-\. ]?\d{4}$\z/i
  validates :recipient_phone, format: PHONE_FORMAT, allow_nil: true
  validates :sender_email, :recipient_email, format: EMAIL_FORMAT, allow_nil: true
  validates :body, :secure_id, presence: true
  # The validations below are tested on message_creator_spec lines 69, 111, and messages_controller_spec lines 48-59, 61-72, 74-85
  validate :neither_email_or_phone_sender, :neither_email_or_phone_recipient


  def sender
    sender_email || sender_phone
  end

  def recipient
    recipient_email || recipient_phone
  end

  def to_param
    secure_id
  end
  private

  def neither_email_or_phone_sender
    if !:sender_email && !:sender_phone
      errors.add(:message, "There must be at least one sender")
    end
  end

  def neither_email_or_phone_recipient
    if !:recipient_email && !:recipient_phone
      errors.add(:message, "There must be at least one sender")
    end
  end

end
