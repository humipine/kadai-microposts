class CreateFavorites < ActiveRecord::Migration[5.0]
  def change
    create_table :favorites do |t|
      t.references :user, foreign_key: true
      t.references :addtofavorite, foreign_key: { to_table: :microposts }
      

      t.timestamps
      
      t.index [:user_id, :addtofavorite_id], unique: true
      
    end
  end
end
