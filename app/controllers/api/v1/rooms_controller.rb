class Api::V1::RoomsController < ApplicationController
  def get_user_id
    if Room::where(id: params[:id]).first.user_id == current_user.id
      user_id = Room::where(id: params[:id]).select(:user_id).first.user_id

      render json: user_id
    else
      user_id = current_user.id

      render json: user_id
    end
  end

  def get_all_messages
    all_messages = Message::where(room_id: params[:id]).joins(:user).select('messages.*, users.name, users.profile_image').order(created_at: :desc)

    render json: all_messages
  end
end
