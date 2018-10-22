require 'open-uri'
require 'nokogiri'
require 'pry'

class Scraper # scrapes a webpage

  def self.scrape_index_page(index_url)
    html = open(index_url)
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
    html = open(profile_url)
    doc = Nokogiri::HTML(html)
    
    student = {}

    social = doc.css('.social-icon-container')
    urls = social.css('a').map { |a| a['href'] }
    ['twitter','linkedin','github'].each { |network|
       if url = urls.find {|a| a.include?(network)}
        student[network.to_sym] = url 
        urls.delete(url)
       end
    }

    student[:blog] = urls.first if urls.first # store any remaing social url as [:blog]
    student[:profile_quote] = doc.css('.profile-quote').text
    student[:bio] = doc.css('.description-holder p').text
    student
  end


end

