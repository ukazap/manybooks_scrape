require 'nokogiri'
require 'open-uri'
require 'logger'
require './schema'
require './helpers'
require './extract-manybooks'

$LOG = Logger.new("scraping.log", "monthly")
$BROWSER = "Mozilla/5.0 (Windows NT 6.3; Win64; x64; rv:39.0) Gecko/20100101 Firefox/39.0 Waterfox/39.0"

puts_and_log("BEGIN SCRAPING")
group = [1]; ('a'..'z').each {|alpha| group << alpha }

group.each do |g|
  # starting point:
  s = 1
  doc = Nokogiri::HTML(open("http://manybooks.net/titles.php?alpha=#{g}&s=#{s}", "User-Agent" => $BROWSER))

  # loop:
  until doc.css('a[title="next"]').count == 0 # move to next group if there's no next
    puts_and_log("BEGIN GROUP #{g.upcase} PAGE #{s}")

    # extract book:
    doc.css('.smallBookTitle').each do |link|
      source_url = "http://manybooks.net#{link[:href]}"
      extract_manybooks(source_url)
    end

    # increment:
    s += 1
    doc = Nokogiri::HTML(open("http://manybooks.net/titles.php?alpha=#{g}&s=#{s}", "User-Agent" => $BROWSER))
  end
end

puts_and_log("FINISHED SCRAPING")