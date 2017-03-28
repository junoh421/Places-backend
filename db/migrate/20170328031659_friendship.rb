class Friendship < ActiveRecord::Migration[5.0]
  def change
  	create_table :friendship do |t|
  	  t.belongs_to :user, null: false
   	  t.string :status, null: false, default: "waiting"
   	  t.timestamps null: false
    end
  end
end
