class CreateTravelPlans < Jennifer::Migration::Base
  def up
    create_table :travel_plans do |t|
    end
  end

  def down
    drop_table :travel_plans
  end
end
