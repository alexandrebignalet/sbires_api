class CreateUserWaitingRooms < ActiveRecord::Migration[5.2]
  def change
    create_table :user_waiting_rooms do |t|
      t.references :user, foreign_key: true
      t.string :waiting_room_id

      t.timestamps
    end

    add_index :user_waiting_rooms, [:user_id, :waiting_room_id], unique: true
  end
end
