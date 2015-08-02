def extract_manybooks(source_url)
  tid = source_url.split("/").last.gsub(".html", "")
  buku = Nokogiri::HTML(open(source_url, "User-Agent" => $BROWSER))

  title = buku.at_css('.booktitle').content
  subtitle = (buku.at_css('.booksubtitle'))? buku.at_css('.booksubtitle').content : nil
  description = (buku.at_css('.notes'))? buku.at_css('.notes').content : nil
  excerpt = (buku.at_css('.excerpt'))? buku.at_css('.excerpt').content : nil

  title_info = {}
  buku.css('.title-info').each do |info|
    key = info.content.split(':')[0].strip.gsub(" ", "_").downcase.to_sym
    val = info.content.split(':')[1].strip
    title_info[key] = val
  end

  genres = (title_info[:genres])? title_info[:genres] : title_info[:genre]
  dl_url = "http://manybooks.net/_scripts/send.php?tid=#{tid}&book=1:epub:.epub:epub"
  cover_url = "http://manybooks.net"+buku.at_css('img[alt="Cover image for "]')[:src].gsub("-thumb", "")

  b = Book.new(
      :title => title,
      :subtitle => subtitle,
      :author => title_info[:author],
      :published_in => title_info[:published],
      :description => description,
      :excerpt => excerpt,
      :language => title_info[:language],
      :word_count => title_info[:wordcount],
      :genres => genres,
      :source_url => source_url,
      :dl_url => dl_url,
      :cover_url => cover_url
    )
  
  if b.save
    puts_and_log("Sukses: #{tid}")
  else
    error = ""
    b.errors.each {|e| error << e.last.to_s}
    puts_and_log("#{error}: #{tid}", "ERROR")
  end
end