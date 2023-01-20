p "Where are you located?"

# user_location = gets.chomp
user_location = "Chicago"
p user_location

gmaps_url = "https://maps.googleapis.com/maps/api/geocode/json?address=#{user_location}&key=#{ENV.fetch("GMAPS_KEY")}"

require("open-uri")

raw_data= URI.open(gmaps_url).read

require "json"

parsed_data= JSON.parse(raw_data)
results_array = parsed_data.fetch("results")
only_result = results_array.at(0)
geo= only_result.fetch("geometry")
loc=geo.fetch("location")
latitude = loc.fetch("lat")
longitude = loc.fetch("lng")
p "Your coordinates are #{latitude},#{longitude}"

dark_sky_url= "https://api.darksky.net/forecast/#{ENV.fetch("DARK_SKY_KEY")}/#{latitude},#{longitude}"
raw_darksky_data= URI.open(dark_sky_url).read
parsed_darksky_data=JSON.parse(raw_darksky_data)
currently= parsed_darksky_data.fetch("currently")
temp=currently.fetch("temperature")
p "It is currently #{temp}°F."

hourly= parsed_darksky_data.fetch("hourly")
access_data = hourly.fetch("data")
1.upto(12) do |precip|
  time=hourly.at(precip)
  p probability_of_rain= time.fetch("precipProbability")
end
