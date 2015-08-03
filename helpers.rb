def integerize(some_string)
  some_string.gsub(/[^0-9a-z\\s]/i, '')
end

def puts_and_log(message, type='INFO')
  puts message
  if type == "ERROR"
    $LOG.error(message)
  else
    $LOG.info(message)
  end
end