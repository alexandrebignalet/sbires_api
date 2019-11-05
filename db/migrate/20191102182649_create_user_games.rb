class CreateUserGames < ActiveRecord::Migration[5.2]
  def change
    create_table :user_games do |t|
      t.references :user, foreign_key: true
      t.string :game_id, null: false

      t.timestamps
    end

    add_index :user_games, [:user_id, :game_id], unique: true
  end
end
