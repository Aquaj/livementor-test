require 'open-uri'
require 'json'
require 'csv'

# Prefixes all elements and nested elements of an Array with a prefix
#
# @param pre [String] the prefix
# @param array_or_element [Array,String] an array of arrays and/or strings or a string
# @return [Array] an array with the elements now prefixed.
def prefix(pre, array_or_element)
  return [pre, array_or_element].join('') if !array_or_element.instance_of? Array
  array_or_element.map { |a_e| prefix(pre, a_e) }
end

# Extract labels from nested Hashs and returns them as an array.
#
# @param hash_or_item [Hash,Object] the Hash to analyze or one of its values.
# @param separator [String] a separator to insert between keys in case of nested Hashes.
# '.' by default.
# @return [Array] an array of the labels.
def labels(hash_or_item, separator: '.')
  return nil unless hash_or_item.instance_of? Hash
  label_array = hash_or_item.map do |key, value|
    if value.instance_of? Hash
      labels(value, separator: separator).map { |v| prefix(key.to_s+separator, v) }.flatten
    else
      key.to_s
    end
  end
  label_array.flatten
end

# Get the values in a possibly-nested hash from an array of keys.
# Basically Hash#dig but with an Array as parameter.
#
# @param json [Hash] a Hash to #dig in.
# @param keys [Array] an Array containing the keys to #dig in order
# @return [Object] the value found at the corresponding digging point.
def get_value(json, keys)
  keys.reduce(json) { |hash, k| hash[k] }
end

# 'CSV-ize' a value to make it safe to write in the CSV by turning it from
# an array of strings to a string of comma-separated words.
#
# @param value [Array,String] the value to csv-ize.
# @return [String] a String of comma separated sub-Strings
def csvize(value)
  [value].join(",")
end

# Turns a JSON file to a CSV file according to the specs
# of the Livementor Technical Test 1.
#
# @param file_path [String] path to the JSON (or URL)
# @param output [String] path to write the CSV at. ! - destructive
def json2csv(file_path, output)
  json = JSON.parse(open(file_path).read())
  json_headers = json.map { |e| labels(e) }.flatten.uniq
  CSV.open(output, 'wb', col_sep: ";") do |csv|
    csv << json_headers
    json.each do |item|
      csv << json_headers.map do |key|
        csvize(get_value(item, key.split('.')))
      end
    end
  end
end

# Allows to use from command-line w/o messing up the testing that imports it.
if __FILE__ == $0
  # Default parameters in case none are provided.
  # (Example: on build in IDE)
  json  = ARGV.length > 0 ? ARGV[0] : "https://gist.githubusercontent.com/gregclermont/ca9e8abdff5dee9ba9db/raw/7b2318efcf8a7048f720bcaff2031d5467a4a2c8/users.json"
  csv   = ARGV.length > 1 ? ARGV[1] : "livementest.csv"

  json2csv(json, csv)
end
