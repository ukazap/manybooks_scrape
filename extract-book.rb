def extract_book(source_url)
  source_url.gsub!(" ", "%20") # on url, replace space char. with %20
  tid = source_url.split("/").last.gsub(".html", "") # get tid from url
  page = Nokogiri::HTML(open(source_url, "User-Agent" => $BROWSER))

  if page.at_css("body").content == "ERROR : PCLZIP_ERR_BAD_FORMAT (-10) : Unable to find End of Central Dir Record signature"
    puts_and_log("\"PCLZIP_ERR_BAD_FORMAT (-10)\": #{tid}", "ERROR")
    return false
  end

  data = Hash.new
  data[:title] = page.at_css('.booktitle').content
  data[:subtitle] = (page.at_css('.booksubtitle'))? page.at_css('.booksubtitle').content : nil
  data[:description] = (page.at_css('.notes'))? page.at_css('.notes').content : nil
  data[:excerpt] = (page.at_css('.excerpt'))? page.at_css('.excerpt').content : nil

  page.css('.title-info').each do |info|
    key = info.content.split(':')[0].strip.gsub(" ", "_").downcase
    val = info.content.split(':')[1].strip

    key = (key == "published")? "published_in" : key
    key = (key == "genre")? "genres" : key
    key = (key == "wordcount")? "word_count" : key

    data[key.to_sym] = val
  end

  data[:source_url] = source_url
  data[:dl_url] = "http://manybooks.net/_scripts/send.php?tid=#{tid}&book=1:epub:.epub:epub"
  data[:cover_url] = "http://manybooks.net"+page.at_css('img[alt="Cover image for "]')[:src].gsub("-thumb", "")

  book = Book.new(data)
  
  if book.save
    puts_and_log("Saved: #{tid}")
  else
    error = ""; book.errors.each {|e| error << e.last.to_s}
    puts_and_log("#{error}: #{tid}", "ERROR")
  end
end