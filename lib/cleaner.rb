# I created this Cleaner module and saved it in the lib folder for several reasons.
# 1) I used a module because none of the functionality requires instantiation, there is no reason to create multiple "Cleaners", and the modularity means it can continue to be improved and used in multiple classes as the project scales.
# 2) I saved it in the library because it clearly doesn't belong in the model, and I prefer the lib. to the helper files.

module Cleaner

  def params_cleaner(allowed)
    #this method is tested in message_creator_spec lines 29-32, and 53-56
    change_recipient(change_sender(allowed))
  end

  def phone_match?(to_check)
    #this method is tested in message_creator_spec lines, 29-32, 53-56, and 83-111
    to_check =~ /\A^1?[-\. ]?(\(\d{3}\)?[-\. ]?|\d{3}?[-\. ]?)?\d{3}?[-\. ]?\d{4}$\z/i
  end

  def email_match?(to_check)
    #this method is tested in message_creator_spec lines, 29-32, 53-56, and 83-111
    to_check =~ /\A(?:[_a-z0-9-]+)(\.[_a-z0-9-]+)*(\+[_a-z0-9-]+)?@([a-z0-9-]+)(\.[a-zA-Z0-9\-\.]+)*(\.[a-z]{2,4})\z/i
  end
  private

  def change_recipient(input_params)
    #This and it's brother (change_sender), have caused me some consternation.  In the event that a sender/ or receiver is not properly input or formatted, I want to short circuit the attempt at saving a message.  The model won't allow it, neither will the 'send_message' method (which will throw an exception if it somehow gets there), so the integrity of the app is ok.  It's just unnecessary computing time. Unfortunately, I haven't found a good way to short-circuit that process,  send the user a useful message, and not break the entirety of the program/ testing setup.  Since it works very well as is, I'm going to leave it this way, but I'm curious how other engineers solve this.
    if phone_match?(input_params[:recipient_phone])
      input_params[:recipient_email] = nil
    elsif email_match?(input_params[:recipient_email])
      input_params[:recipient_phone] = nil
    else
      p "A Recipient was not input properly. This message will not save in the Database"
    end
    input_params
  end

  def change_sender(input_params)
    if phone_match?(input_params[:sender_phone])
      input_params[:sender_email] = nil
    elsif email_match?(input_params[:sender_email])
      input_params[:sender_phone] = nil
    else
      p "A Sender was not input properly. This message will not save in the Database"
    end
    input_params
  end

end
