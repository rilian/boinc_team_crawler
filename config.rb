@settings = YAML.load(File.read('settings.yml'))
puts "Loaded Settings #{@settings.inspect}"

@projects = YAML.load(File.read('projects.yml'))
puts "Loaded Projects #{@projects.inspect}"

USERS_SEARCH_QUERY = "user_search.php?action=search&search_string=&country=#{@settings['target_country']}&profile=either&team=either&search_type=total"

# Set up database schema
@db = SQLite3::Database.new('crunchers.sqlite3')

