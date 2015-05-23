require 'nokogiri'
require 'open-uri'
require 'pry'
require 'capybara'

url = 'http://www.cbr.washington.edu/dart/query/adult_daily'
search_url = 'http://www.cbr.washington.edu/dart/cs/php/rpt/adult_daily.php?sc=1&outputFormat=html&year=2015&proj=#{project}&span=no&startdate=1%2F1&enddate=12%2F31&run=&s#{year}=2015&eyear=#{year}'
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
    projects << project.attributes["value"].value
  end
end

def test_scrape(search_url, years, projects)
  years.each do |year|
    projects.each do |project|
      puts "http://www.cbr.washington.edu/dart/cs/php/rpt/adult_daily.php?sc=1&outputFormat=csv&year=#{year}&proj=#{project}&span=no&startdate=1%2F1&enddate=12%2F31&run=&s#{year}=2015&eyear=#{year}"
    end
  end
end

test_scrape(search_url, years, projects)
