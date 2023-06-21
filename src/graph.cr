require "crystal-gql"
require "json"



def expanded_info (ids)
  api = GraphQLClient.new "https://rickandmortyapi.com/graphql"
  infos = ids.map do |id|
    begin
      data, error, loading = api.query("{
        location (id: #{id}) {
        name
        type
        dimension
          }
      }")

      if data && data["location"]
        {
          id: id,
          name: data["location"]["name"],
          type: data["location"]["type"],
          dimension: data["location"]["dimension"]
        }
        end
      rescue
        {
          id: id,
          name: "unknown",
          type: "unknown",
          dimension: "unknown"
        }
      end
    end
  end

