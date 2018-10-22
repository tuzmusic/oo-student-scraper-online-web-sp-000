require 'open-uri'
require 'nokogiri'
require 'pry'

class Scraper # scrapes a webpage

  def self.scrape_index_page(index_url)
    html = open('./fixtures/student-site/index.html')
    doc = Nokogiri::HTML(html)
    students_html = doc.css '.student-card'  
    students = students_html.map { |info|
      student = {
        name: info.css('.student-name').text,
        location: info.css('.student-location').text,
        profile_url: info.css('a').first['href']
      }      
    }
  end

  def self.scrape_profile_page(profile_url)
    
  end

end

