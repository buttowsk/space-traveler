require "./config/initializers/database"
require "./src/models/*"
require "./db/migrations/*"
require "sam"

load_dependencies "jennifer"

Sam.help
