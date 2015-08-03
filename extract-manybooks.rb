def extract_manybooks(source_url)
  source_url.gsub!(" ", "%20") # on url, replace space char. with %20
  tid = source_url.split("/").last.gsub(".html", "") # get tid from url
  page = Nokogiri::HTML(open(source_url, "User-Agent" => $BROWSER))

  if page.at_css("body").content == "ERROR : PCLZIP_ERR_BAD_FORMAT (-10) : Unable to find End of Central Dir Record signature"
    puts_and_log("\"PCLZIP_ERR_BAD_FORMAT (-10)\": #{tid}", "ERROR")
    return false
  end

  title = page.at_css('.booktitle').content
  subtitle = (page.at_css('.booksubtitle'))? page.at_css('.booksubtitle').content : nil
  description = (page.at_css('.notes'))? page.at_css('.notes').content : nil
  excerpt = (page.at_css('.excerpt'))? page.at_css('.excerpt').content : nil

  title_info = {}
  page.css('.title-info').each do |info|
    key = info.content.split(':')[0].strip.gsub(" ", "_").downcase.to_sym
    val = info.content.split(':')[1].strip
    title_info[key] = val
  end

  dl_url = "http://manybooks.net/_scripts/send.php?tid=#{tid}&book=1:epub:.epub:epub"
  cover_url = "http://manybooks.net"+page.at_css('img[alt="Cover image for "]')[:src].gsub("-thumb", "")

  book = Book.new(
      :title => title,
      :subtitle => subtitle,
      :author => title_info[:author],
      :published_in => title_info[:published],
      :description => description,
      :excerpt => excerpt,
      :language => title_info[:language],
      :word_count => title_info[:wordcount],
      :genres => (title_info[:genres])? title_info[:genres] : title_info[:genre],
      :source_url => source_url,
      :dl_url => dl_url,
      :cover_url => cover_url
    )
  
  if book.save
    puts_and_log("Saved: #{tid}")
  else
    error = ""; book.errors.each {|e| error << e.last.to_s}
    puts_and_log("#{error}: #{tid}", "ERROR")
  end
end