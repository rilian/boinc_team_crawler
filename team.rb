require 'yaml'
require 'debugger'
require 'faraday'
require 'nokogiri'

load 'config.rb'
load 'cruncher.rb'
load 'utils.rb'

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
          parse_crunchers(table)
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


  #debugger

  #puts '1'
  # Delay before next project
  # puts "Sleeping #{@settings['crawl_delay']} sec"
  # sleep(@settings['crawl_delay'])
end

puts 'Done'
