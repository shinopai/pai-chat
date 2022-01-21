# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  def create
    user_id =  User.find_by(email: params[:user][:email]).id

    if Room::find_by(user_id: user_id).nil?
      Room.create(
        user_id: user_id
      )
    end
    super
  end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end

  # The path used after sign in.
  def after_sign_in_path_for(resource)
    room_id = Room::where(user_id: resource).select(:id).first.id
    show_room_path(room_id)
  end

  # The path used after sign out.
  def after_sign_out_path_for(resource)
    new_user_session_path
  end
end
