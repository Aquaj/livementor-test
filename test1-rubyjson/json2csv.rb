require 'open-uri'
require 'json'
require 'csv'

def json2csv(file_path, output)
  json = JSON.parse(open(file_path).read())
  CSV.open(output, 'wb', col_sep: ";") do |csv|
    csv << json.to_a
  end
end

json  = ARGV.length > 0 ? ARGV[0] : "https://gist.githubusercontent.com/gregclermont/ca9e8abdff5dee9ba9db/raw/7b2318efcf8a7048f720bcaff2031d5467a4a2c8/users.json"
csv   = ARGV.length > 1 ? ARGV[1] : "livementest.csv"

json2csv(json, csv)
