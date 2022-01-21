class Api::V1::LikesController < ApplicationController
  def create
    user = User.find(params[:user_id])
    message = Message.find(params[:message_id])
    like = Like.create(
      user_id: user.id,
      message_id: message.id
    )

    isLiked =  Like::where(user_id: user.id).where(message_id: message.id).any?

    render json: isLiked
  end

  def remove_like
    like = Like::where(user_id: params[:user_id]).where(message_id: params[:message_id]).first
    like.destroy
  end

  def get_all_liked_messages
    all_liked_messages = Like::where(user_id: params[:id]).pluck(:message_id)

    render json: all_liked_messages
  end
end
