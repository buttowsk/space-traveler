require "jennifer"
require "jennifer_sqlite3_adapter"

Jennifer::Config.configure do |conf|
  conf.adapter = "sqlite3"
  conf.host = "./db"
  conf.db = "test.db"
end