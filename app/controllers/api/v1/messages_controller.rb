class Api::V1::MessagesController < ApplicationController
  def index
  end

  def create
    message = Message.new
    message.body = message_params[:body]
    message.user_id = message_params[:user_id]
    message.room_id = message_params[:room_id]
    message.save
  end


  private
  def message_params
    params.require(:message).permit(:body, :user_id, :room_id)
  end
end
