require 'open-uri'
require 'json'
require 'csv'

def json2csv(file_path)
  json = JSON.parse(open(file_path).read())

end

argument = ARGV.length > 0 ? ARGV[0] : "https://gist.githubusercontent.com/gregclermont/ca9e8abdff5dee9ba9db/raw/7b2318efcf8a7048f720bcaff2031d5467a4a2c8/users.json"

json2csv(argument)
p argument
