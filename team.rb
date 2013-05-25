require 'yaml'
require 'debugger'
require 'faraday'
require 'nokogiri'
require 'sqlite3'

load 'config.rb'
load 'cruncher.rb'
load 'utils.rb'

@crunchers = []

@projects['projects'].each do |project|
  puts "Crawling Project #{project['url']}"

  # Find users not in Team
  search_url = "#{project['url']}#{USERS_SEARCH_QUERY}"
  puts "Loading #{search_url}"

  begin
    response = Faraday.get search_url

    if response.success?
      puts 'Success'

      page = Nokogiri::HTML(response.body)

      tables = page.css('table')
      tables.each do |table|
        if table.to_s.include?('Name')
          @crunchers << parse_crunchers(table, project['url'])
        end
      end
    else
      puts "Error getting #{search_url}"
      puts "Status #{response.status}"
      puts "Headers #{response.headers}"
      puts "Body #{response.body}"
    end
  rescue Exception => e
    puts "Error:\n\n#{e.message}\n\n#{e.backtrace}\n"
  end
end

@crunchers = @crunchers.flatten

@crunchers.each do |cruncher|
  puts cruncher.inspect
  # Insert into DB
end

puts 'Done'
