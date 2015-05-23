require 'nokogiri'
require 'open-uri'
require 'pry'
require 'capybara'

url = 'http://www.cbr.washington.edu/dart/query/adult_daily'
directory_name = "fish_counts"

Dir.mkdir(directory_name) unless File.exists?(directory_name)

doc = Nokogiri::HTML(open(url).read)

years = Array.new
doc.css("select").first.children.each do |year|
  year = year.children.text
  if !year.empty?
    years << year.to_i
  end
end

projects = Array.new
doc.css("select")[1].children.each do |project|
  if !project.children.empty?
    projects << project.text
  end
end

# doc.css("select").first.children.each do |year|
#   year = year.child
#   if !year.empty?
#   end
# end

def test_scrape(url)
  binding.pry
  visit(url)
  save_and_open_page
  select('CSV File')
  select(years.first, from: 'select#year-select')
end

test_scrape(url)
