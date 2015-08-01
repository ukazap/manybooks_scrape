def integerize(some_string)
  some_string.gsub(/[^0-9a-z\\s]/i, '')
end

def puts_and_log(message)
  puts message
  $LOG.debug(message)
end