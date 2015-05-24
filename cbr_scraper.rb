require 'nokogiri'
require 'open-uri'

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
    projects << project.attributes["value"].value
  end
end

def daily_count_scrape(years, projects)
  years.each do |year|
    projects.each do |project|
      csv = "http://www.cbr.washington.edu/dart/cs/php/rpt/adult_daily.php?sc=1&outputFormat=csv&year=#{year}&proj=#{project}&span=no&startdate=1%2F1&enddate=12%2F31&run=&syear=#{year}&eyear=#{year}&avg=1"
      remote_data = open(csv).read
      if remote_data.include?("Project,Date,Chinook Run")
        my_local_file = open("fish_counts/project-#{project}-year-#{year}.csv", "w")
        my_local_file.write(remote_data)
        my_local_file.close
      end
    end
  end
end

daily_count_scrape(years, projects)
