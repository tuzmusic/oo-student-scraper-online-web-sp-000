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
    social = doc.css('.social-icon-container')
    
    student = {}
    
    urls = social.css('a').map { |a| a['href'] }
    ['twitter','linkedin','github'].each { |network|
      student[network.to_sym] = urls.find {|a| a.include?(network)}
    }
    binding.pry
    student[:blog] = urls.last

    student[:profile_quote] = doc.css('.profile-quote').text
    student[:bio] = doc.css('.description-holder p').text
    # binding.pry

    student
  end


end

