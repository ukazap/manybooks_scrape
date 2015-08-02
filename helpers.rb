def sudah_buntu(doc)
  return (doc.css('a[title="next"]').count == 0)? true : false
end

def integerize(some_string)
  some_string.gsub(/[^0-9a-z\\s]/i, '')
end

def puts_and_log(message, type='INFO')
  puts message
  case type
  when "ERROR"
    $LOG.error(message)
  else
    $LOG.info(message)
  end
end