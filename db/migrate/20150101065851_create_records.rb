class CreateRecords < ActiveRecord::Migration
  def change
    create_table :records do |t|
      t.belongs_to :health_state, index: true, null: false
      t.belongs_to :user, index: true, null: false

      t.timestamps null: false
    end
    add_foreign_key :records, :users
    add_foreign_key :records, :health_states
  end
end
