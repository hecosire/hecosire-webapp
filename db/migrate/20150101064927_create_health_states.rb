class CreateHealthStates < ActiveRecord::Migration

  def change
    create_table :health_states do |t|
      t.string :name
      t.timestamps null: false
    end

    add_index :health_states, :name, :unique => true

    HealthState.create :name => "healthy"
    HealthState.create :name => "comingdown"
    HealthState.create :name => "sick"
    HealthState.create :name => "recovering"
  end
end
