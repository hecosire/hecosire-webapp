class CreateCares < ActiveRecord::Migration
  def change
    create_table :cares do |t|
      t.integer :user_id
      t.integer :care_taker_id

      t.timestamps null: false
    end
  end
end
