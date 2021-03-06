##
# Parsers Crunchers into array of {Cruncher}
#
# Params:
#  - table {Nokogiri::XML::Element}
#
# Returns:
#  - Array of {Cruncher}
#
def parse_crunchers(table, project_url)
  crunchers = []
  table.css('tr').each do |cruncher_row|
    cruncher = Cruncher.new
    cruncher.project_url = project_url
    cruncher.team_name = ''
    cruncher.country = ''
    cruncher.credits = '0'

    if cruncher_row.css('td').count > 0
      if cruncher_row.css('td')[0].css('a').count > 0
        # UserId and Name
        name_anchor = cruncher_row.css('td')[0].css('a').last
        cruncher.user_id = name_anchor['href'].scan(/userid=([0-9]+)/).flatten[0] || 0
        cruncher.name = name_anchor.children.to_s.force_encoding('UTF-8')

        # Team name
        if cruncher_row.css('td')[1] && cruncher_row.css('td')[1].css('a').count > 0
          cruncher.team_name = cruncher_row.css('td')[1].css('a').children.to_s
        end

        # Country
        if cruncher_row.css('td')[4]
          cruncher.country = cruncher_row.css('td')[4].children.to_s
        end

        # Credits
        if cruncher_row.css('td')[3]
          cruncher.credits = cruncher_row.css('td')[3].children.to_s
          cruncher.credits = cruncher.credits.gsub(',', '').gsub('.', '')
        end

        if @settings['target_team'] != cruncher.team_name
          crunchers << cruncher
        end
      end
    end
  end

  puts "Found #{crunchers.count} new crunchers"
  crunchers
end
