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
            episode {
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
          residents: data["location"]["residents"].as_a
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


def calc_popularity(stops_infos)
  parse = JSON.parse(stops_infos).as_a
  popularity = parse.map do |info|
    sum = info["residents"].as_a.map do |resident|
      resident["episode"].size
    end.sum
    {
      id: info["id"],
      name: info["name"],
      type: info["type"],
      dimension: info["dimension"],
      popularity: sum}
  end
  popularity
end

def otimizar_travel_stops(travel_stops)

end

def query_rules(optimize, expand, ids)
  if expand && !optimize
    get_expanded_info(ids)
  elsif optimize && !expand
    infos = get_expanded_info(ids)
    calc_popularity(infos.to_json)
  else
    ids
  end
end

