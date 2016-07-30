class Message < ActiveRecord::Base
  EMAIL_FORMAT = /\A(?:[_a-z0-9-]+)(\.[_a-z0-9-]+)*(\+[_a-z0-9-]+)?@([a-z0-9-]+)(\.[a-zA-Z0-9\-\.]+)*(\.[a-z]{2,4})\z/i
  PHONE_FORMAT = /\A^1?[-\. ]?(\(\d{3}\)?[-\. ]?|\d{3}?[-\. ]?)?\d{3}?[-\. ]?\d{4}$\z/i
  validates :recipient_phone, format: PHONE_FORMAT, allow_nil: true
  validates :sender_email, :recipient_email, format: EMAIL_FORMAT, allow_nil: true
  validates :body, :secure_id, presence: true
  validate :neither_email_or_phone_sender, :neither_email_or_phone_recipient

  def neither_email_or_phone_sender
    if !:sender_email && !:sender_phone
      errors.add(:sender_email, "There must be at least one sender")
    end
  end

  def neither_email_or_phone_recipient
    if !:recipient_email && !:recipient_phone
      errors.add(:recipient_email, "There must be at least one sender")
    end
  end

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
