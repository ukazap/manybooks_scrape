require 'nokogiri'
require 'open-uri'
require 'logger'
require './schema'
require './helpers'
require './extract-manybooks'

$LOG = Logger.new("scraping.log", "monthly")
$BROWSER = "Mozilla/5.0 (Windows NT 6.3; Win64; x64; rv:39.0) Gecko/20100101 Firefox/39.0 Waterfox/39.0"

puts_and_log("BEGIN SCRAPING")
grup = %w[1 a b c d e f g h i j k l m n o p q r s t u v w x y z]

grup[0..grup.size].each do |g|
  # mulai dari sini:
  s = 1
  url = "http://manybooks.net/titles.php?alpha=#{g}&s=#{s}"
  doc = Nokogiri::HTML(open(url, "User-Agent" => $BROWSER))

  # loop:
  until sudah_buntu(doc)
    puts_and_log("Begin ABJAD #{g} HALAMAN #{s}")

    doc.css('.smallBookTitle').each do |link|
      source_url = "http://manybooks.net#{link[:href]}"
      extract_manybooks(source_url)
    end

    # inkremen:
    s += 1
    url = "http://manybooks.net/titles.php?alpha=#{g}&s=#{s}"
    doc = Nokogiri::HTML(open(url, "User-Agent" => $BROWSER))
  end
end

puts_and_log("FINISHED SCRAPING")