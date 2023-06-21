class TravelPlan < Jennifer::Model::Base

  mapping(
    id: Primary64,
  )

  has_many :travel_stops, TravelStop, dependent: :destroy
end



class TravelStop < Jennifer::Model::Base

  mapping(
    id: Primary64,
    stop_id: Int64,
    travel_plan_id: Int64?,
  )

  belongs_to :travel_plan, TravelPlan
end
