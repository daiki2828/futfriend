class Public::RoomsController < ApplicationController

  def index
    @rooms = Room.all
    @user = current_user
    @current_user_rooms= current_user.user_rooms
    myRoomIds = []
   @current_user_rooms.each do | user_room |
      myRoomIds << user_room.room.id
    end
    @another_user_rooms = UserRoom.where(room_id: myRoomIds).where('user_id != ?', @user.id)
  end

end
