CREATE TABLE migration_versions (version text NOT NULL);
CREATE TABLE travel_plans (id integer PRIMARY KEY AUTOINCREMENT);
CREATE TABLE IF NOT EXISTS "travel_stops"(id integer PRIMARY KEY, travel_plan_id integer, stop_id integer,FOREIGN KEY (travel_plan_id) REFERENCES travel_plans(id) ON UPDATE RESTRICT ON DELETE RESTRICT);
