module Cleaner

  def params_cleaner(allowed)
    change_recipient(change_sender(allowed))
  end

  def phone_match?(to_check)
    to_check =~ /\A^1?[-\. ]?(\(\d{3}\)?[-\. ]?|\d{3}?[-\. ]?)?\d{3}?[-\. ]?\d{4}$\z/i
  end

  def email_match?(to_check)
    to_check =~ /\A(?:[_a-z0-9-]+)(\.[_a-z0-9-]+)*(\+[_a-z0-9-]+)?@([a-z0-9-]+)(\.[a-zA-Z0-9\-\.]+)*(\.[a-z]{2,4})\z/i
  end
  private

  def change_recipient(input_params)
    if phone_match?(input_params[:recipient_phone])
      input_params[:recipient_email] = nil
    elsif email_match?(input_params[:recipient_email])
      input_params[:recipient_phone] = nil
    else
      p "enter a valid phone or email"
    end
    input_params
  end

  def change_sender(input_params)
    if phone_match?(input_params[:sender_phone])
      input_params[:sender_email] = nil
    elsif email_match?(input_params[:sender_email])
      input_params[:sender_phone] = nil
    else
      p 'Enter a valid phone number or email'
    end
    input_params
  end

end
