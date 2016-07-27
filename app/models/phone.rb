class Phone < ActiveRecord::Base
  # a class to take a number and turn it into a 10 digit number string
  #Don't forget to write tests for this
  include Texter

  def clean_number
    number = self.number.scan(/\d+/).join
    number[0] = "1" ? number[0] = '' : number
    number unless number.length != 10
  end

end
