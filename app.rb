require 'nokogiri'
require 'open-uri'
require 'logger'
require './schema'
require './helpers'
require './extract-manybooks'

$LOG = Logger.new("scraping.log", "monthly")
grup = %w[1 a b c d e f g h i j k l m n o p q r s t u v w x y z]

grup.each do |g|
  # mulai dari sini:
  s = 1
  url = "http://manybooks.net/titles.php?alpha=#{g}&s=#{s}"
  doc = Nokogiri::HTML(open(url))

  # loop:
  until sudah_buntu(doc)
    doc.css('.smallBookTitle').each do |link|
      puts_and_log("Begin ABJAD #{g} HALAMAN #{s}")
      source_url = "http://manybooks.net#{link[:href]}"
      extract_manybooks(source_url)
    end

    # inkremen:
    s += 1
    url = "http://manybooks.net/titles.php?alpha=#{g}&s=#{s}"
    doc = Nokogiri::HTML(open(url))
  end
end
