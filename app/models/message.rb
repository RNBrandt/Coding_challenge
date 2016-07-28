class Message < ActiveRecord::Base
  # Messages are all saved together regardless of whether they are texts  or emails. That means EVERYTHING that was assigned to the emails needs to also be assigned to the text.
  # To simplify everything, this class should be able to distinguish Emails vs Phone numbers. Under most situations, I prefer to begin with the front end and work on the UX to give the user a clear dichotomy between choices and format, but for the sake of initial MVP, I will add some instructions on, and the most robust regex I can muster
  EMAIL_FORMAT = /\A(?:[_a-z0-9-]+)(\.[_a-z0-9-]+)*(\+[_a-z0-9-]+)?@([a-z0-9-]+)(\.[a-zA-Z0-9\-\.]+)*(\.[a-z]{2,4})\z/i
  PHONE_FORMAT = /\A^1?[-\. ]?(\(\d{3}\)?[-\. ]?|\d{3}?[-\. ]?)?\d{3}?[-\. ]?\d{4}$\z/i
  #This part is going to have to be reworked. I like the elegance of it, but I'm not able to make it work as is.
  # I just want to make sure I use the hints that have been laid out for me.
  validates :recipient_phone, format: PHONE_FORMAT, allow_nil: true
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
