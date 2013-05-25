@settings = YAML.load(File.read('settings.yml'))
puts "Loaded Settings #{@settings.inspect}"

@projects = YAML.load(File.read('projects.yml'))
puts "Loaded Projects #{@projects.inspect}"

USERS_SEARCH_QUERY = "user_search.php?action=search&search_string=&country=#{@settings['target_country']}&profile=either&team=either&search_type=total"

@db = SQLite3::Database.new('crunchers.sqlite3')

# Set up database schema and perform cleanup
@db.execute 'CREATE TABLE IF NOT EXISTS crunchers (
  id INTEGER PRIMARY KEY,
  user_id INTEGER,
  name TEXT,
  project_url TEXT,
  team_name TEXT,
  country TEXT,
  credits TEXT
);'
@db.execute 'CREATE UNIQUE INDEX IF NOT EXISTS unique_user_id_name_project_url ON crunchers (user_id, name, project_url);'
@db.execute 'DELETE FROM crunchers;'
