# pull the english and georgian country names and merge into a csv
require 'csv'
require 'open-uri'
require 'nokogiri'

english_url = 'https://en.wikipedia.org/wiki/ISO_3166-1'
georgian_url = 'https://ka.wikipedia.org/wiki/ISO_3166-1'
csv_file_name = 'country_names.csv'
country_names = [] # order is iso number, iso 3-digit alpha, en, ka

# english
puts "getting english names"
page = Nokogiri::HTML(open(english_url))
table = page.css('table').first
rows = table.css('tr')
puts "- found #{rows.length} records"
rows.each_with_index do |row, i|
  if i > 0
    cols = row.css('td')
    # td order: name, 2-digit alpha, 3-digit alpha, number
    country_names << [cols[3].text.strip, cols[2].text.strip, cols[0].text.strip]
  end
end

puts ""

# georgian
puts "getting georgian names"
page = Nokogiri::HTML(open(georgian_url))
table = page.css('table').first
rows = table.css('tr')
puts "- found #{rows.length} records"
rows.each_with_index do |row, i|
  if i > 0
    cols = row.css('td')
    # td order: name, number, 3-digit alpha, 2-digit alpha

    # look for english record match
    index = country_names.index{|x| x[0] == cols[1].text.strip}
    if index.nil?
      # no match but still add record without english
      country_names << [cols[1].text.strip, cols[2].text.strip, nil, cols[0].text.strip]
    else
      country_names[index] << cols[0].text.strip
    end
  end
end

puts ""

# write out csv
puts "writing csv"
CSV.open(csv_file_name, 'wb') do |csv|
  csv << ['iso num', 'iso_alpha', 'en_name', 'ka_name']
  country_names.each do |country|
    csv << country
  end
end
