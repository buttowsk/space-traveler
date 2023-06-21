class CreateTravelStops < Jennifer::Migration::Base
  def up
    create_table :travel_stops do |t|
      t.integer :travel_plan_id
      t.integer :stop_id
      t.reference :travel_plan
    end
  end

  def down
    drop_foreign_key :travel_stops, :travel_plans if foreign_key_exists? :travel_stops, :travel_plans
    drop_table :travel_stops if table_exists? :travel_stops
  end
end

