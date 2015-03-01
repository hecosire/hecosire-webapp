class AddTimezoneColumnToUsers < ActiveRecord::Migration
  def change
    add_column :users, :time_zone, :string, default: "Melbourne"
  end
end
