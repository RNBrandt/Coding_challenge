class MessagesController < ApplicationController
  def new
    @message = Message.new
  end

  def create
    action = MessageCreator.new(params)
    if action.ok?
      flash[:message] = "Message sent"
      redirect_to new_message_path
    else
      # From some debugging messages I can see this is getting called, but there's no clear reason why it's broken.
      @message = action.message
      render :new
    end
  end
end
