require "../config/config"
require "json"
require "./graph"

before_all "/travel_plans" do |env|
  env.response.content_type = "application/json"
end


get "/travel_plans" do |env|
  travel_plans = TravelPlan.all().to_a

  result = travel_plans.map do |travel_plan|
    stops = travel_plan.travel_stops.map do |travel_stop|
      travel_stop.stop_id
    end

    expand = env.params.query.has_key?("expand") && env.params.query["expand"] == "true"
    optimize = env.params.query.has_key?("optimize") && env.params.query["optimize"] == "true"

    travel_stops = query_rules(optimize, expand, stops)

    { id: travel_plan.id, travel_stops: travel_stops }
  end

  env.response.status_code = 200
  result.to_json
end

post "/travel_plans" do |env|
  travel_plan = TravelPlan.new()
  travel_plan.save
  travel_ids = env.params.json["travel_stops"].as(Array)
  travel_ids.map do |id|
    travel_stop = TravelStop.new(values: {stop_id: id.to_s.to_i64})
    travel_stops = travel_plan.add_travel_stops(travel_stop)
  end

  stops = travel_plan.travel_stops.map do |travel_stop|
    travel_stop.stop_id
  end

  env.response.status_code = 201
  {id: travel_plan.id, travel_stops: stops}.to_json
end


get "/travel_plans/:id" do |env|
  id = env.params.url["id"].not_nil!
  travel_plan = TravelPlan.find(id: id.to_s.to_i64)

  if travel_plan.nil?
    env.response.status_code = 404
    next
  end

  stops = travel_plan.travel_stops.map do |travel_stop|
    travel_stop.stop_id
  end
  
  if env.params.query.has_key?("expand") && env.params.query["expand"] === "true"
    infos = query_rules(false, true, stops)
    env.response.status_code = 200
    {id: travel_plan.id, travel_stops: infos}.to_json
  else
    env.response.status_code = 200
    {id: travel_plan.id, travel_stops: stops}.to_json
  end
  
end


put "/travel_plans/:id" do |env|
  id = env.params.url["id"].not_nil!
  travel_plan = TravelPlan.find!(id: id.to_s.to_i64)
  travel_plan.travel_stops.each do |travel_stop|
    travel_stop.destroy
  end
  travel_plan.save

  travel_ids = env.params.json["travel_stops"].as(Array)
  stops = travel_ids.map do |id|
    travel_stop = TravelStop.new(values: {stop_id: id.to_s.to_i64})
    travel_plan.add_travel_stops(travel_stop)
    travel_stop.stop_id
  end

  env.response.status_code = 200
  {id: travel_plan.id, travel_stops: stops}.to_json
end

delete "/travel_plans/:id" do |env|
  id = env.params.url["id"].not_nil!
  travel_plan = TravelPlan.find!(id: id.to_s.to_i64)
  travel_plan.destroy

  env.response.status_code = 204
end


Kemal.run