require 'texter'
class Phone
  # a class to take a number and turn it into a 10 digit number string
  #Don't forget to write tests for this
  include Texter
  def initialize(message_object)
    @number = message_object.recipient_phone
  end

  def clean_number
    number = @number.scan(/\d+/).join
    # number[0] = "1" ? number[0] = '' : number
    # number = remove_one(number)
    # p number
    number unless number.length != 10
  end
  def remove_one(number)
    if number[0] == "1"
      number[0] = ''
    end
  end
end
