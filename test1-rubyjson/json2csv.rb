require 'open-uri'
require 'json'
require 'csv'

def prefix(pre, array_or_element)
  return [pre, array_or_element].join('.') if !array_or_element.instance_of? Array
  array_or_element.map { |a_e| prefix(pre, a_e) }
end

def labels(hash_or_item)
  return nil unless hash_or_item.instance_of? Hash
  hash_or_item.map do |key, value|
    if value.instance_of? Hash
      labels(value).map { |v| prefix(key, v) }
    else
      key
    end
  end
end

def json2csv(file_path, output)
  json = JSON.parse(open(file_path).read())
  json_headers = json.map { |e| labels(e) }.flatten.uniq
  p json_headers
  CSV.open(output, 'wb', col_sep: ";") do |csv|
    csv << [json_headers]
  end
end

json  = ARGV.length > 0 ? ARGV[0] : "https://gist.githubusercontent.com/gregclermont/ca9e8abdff5dee9ba9db/raw/7b2318efcf8a7048f720bcaff2031d5467a4a2c8/users.json"
csv   = ARGV.length > 1 ? ARGV[1] : "livementest.csv"

json2csv(json, csv)
