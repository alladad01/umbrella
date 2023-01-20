p "Where are you located?"

# user_location = gets.chomp
user_location = "Chicago"
puts user_location

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
puts "Your coordinates are #{latitude},#{longitude}"

dark_sky_url= "https://api.darksky.net/forecast/#{ENV.fetch("DARK_SKY_KEY")}/#{latitude},#{longitude}"
raw_darksky_data= URI.open(dark_sky_url).read
parsed_darksky_data=JSON.parse(raw_darksky_data)
currently= parsed_darksky_data.fetch("currently")
temp=currently.fetch("temperature")
puts "It is currently #{temp}°F."

hourly= parsed_darksky_data.fetch("hourly")
access_data = hourly.fetch("data")
next_hour=access_data.at(1)
next_hour_summary=next_hour.fetch("summary")
puts "Next hour: #{next_hour_summary}"

precip_prob_threshold = 0.10
any_precipitation = false
i=1
while i<=12 
  time=access_data.at(i)
  probability_of_rain= time.fetch("precipProbability")
  any_precipitation = true
  puts "The probabiliy of rain in the next #{i} hours is #{probability_of_rain}"
  i=i+1
end
if any_precipitation == true
  puts "You might want to carry an umbrella!"
else any_precipitation == true
  puts "You probably won't need an umbrella today!"
end
