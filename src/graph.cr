require "crystal-gql"
require "../config/config"
require "json"


def get_expanded_info(ids)
  api = GraphQLClient.new "https://rickandmortyapi.com/graphql"
  infos = ids.map do |id|
    begin
      data, error, loading = api.query("{
        location (id: #{id}) {
          id
          name
          type
          dimension
          residents {
            episode{
              name
            }
          }
        }
      }")

      if data && data["location"]
        {
          id: id,
          name: data["location"]["name"],
          type: data["location"]["type"],
          dimension: data["location"]["dimension"],
          residents: data["location"]["residents"]
        }
      else
        {
          id: id,
          name: "unknown",
          type: "unknown",
          dimension: "unknown",
          residents: "unknown"
        }
      end
    rescue
      {
        id: id,
        name: "unknown",
        type: "unknown",
        dimension: "unknown",
        residents: "unknown"
      }
    end
  end
  infos
end


def calcular_popularidade(stops_infos)
  popularity = stops_infos.map do |info|
    info["residents"].size
  end 
  popularity
end

def otimizar_travel_stops(travel_stops)
  travel_stops.sort_by! do |stop|
    [stop[:dimension], -stop[:popularity], stop[:name]]
  end

  travel_stops.map { |stop| stop[:id] }
end

def query_rules(optimize, expand, ids)
  if expand && !optimize
    get_expanded_info(ids)
  elsif optimize && !expand
    infos = get_expanded_info(ids)
    calcular_popularidade(infos.to_a)
  else
    ids
  end
end

