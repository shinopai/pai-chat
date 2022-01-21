class RoomsController < ApplicationController
  before_action :authenticate_user!

  def index

  end

  def show_room
    @room_id = Room::where(user_id: current_user).first.id

    render 'index'
  end

  def show_all_rooms
    @rooms = Room::where.not(user_id: params[:user_id]).joins(:user).select('rooms.id, users.id AS userId, users.name, users.profile_image')
    @user_id = User.find(params[:user_id]).id

    render 'show'
  end
end
