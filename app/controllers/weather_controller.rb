require 'open-uri'
require 'nokogiri'
require 'json'
require 'whenever'

class WeatherController < ApplicationController

	BOM_BASE = 'http://www.bom.gov.au/'
	BOM_SUB = '/observations/'
	BASE_1 = 'http://www.bom.gov.au'
	API_KEY = '444dab07e0ea082af9e24d7d98fb6a06'
	BASE_URL = 'https://api.forecast.io/forecast'

	def retrieve_bom
		#allow multiple cities
		City.all.each do |city|
			doc_url = "#{BOM_BASE}#{city.state}#{BOM_SUB}#{city.name.downcase}.shtml"
			doc = Nokogiri::HTML(open(doc_url))
			content = doc.css("#t#{city.name.upcase} tbody tr")
			content.each do |line|
				station = Station.new
				station.name = line.css('th a')[0].text
				#if it is a new station, store it into database
				if Station.find_by_name(station.name).blank?
					url = line.css('th a')[0]['href']
					station_info = Nokogiri::HTML(open("#{BASE_1}#{url}"))
					details_table = station_info.css('.stationdetails')
					details = details_table.css('tr')
					longitude = details.css('td')[4].text
					latitude = details.css('td')[3].text
					float_regex = /(-?)[0-9]*\.[0-9]+/
					longitude = Float(float_regex.match(longitude)[0])
					latitude = Float(float_regex.match(latitude)[0])
					station.longitude = longitude
					station.latitude = latitude
					station.city = city
					station.save
				end
				#store other types of data like rainfall, temperature, source, time and wind
				rainfall = Rainfall.new
				rainfall.amount = line.css('td')[12].text
				wind = Wind.new
				wind.direction = line.css('td')[6].text
				wind.speed = line.css('td')[7].text.to_d
				temp = Temperature.new
				temp.current = line.css('td')[1].text.to_d
				temp.dew = line.css('td')[3].text.to_d
				weather = Weather.new
				weather.source = 'bom'
				weather.time = line.css('td')[0].text
				weather.rainfall = rainfall
				weather.station = Station.find_by_name(station.name)
				weather.wind = wind
				weather.temperature = temp
				#assign it to a fetched data group
				weather.fetch = Fetch.last
				weather.save
			end
		end
	end


	def retrieve_forecast
		station_list = Station.all.to_a
		station_list.each do |db_station|
			lat_long = "#{db_station.latitude},#{db_station.longitude}"
			url = "#{BASE_URL}/#{API_KEY}/#{lat_long}?units=si"
			forecast = JSON.parse(open(url).read)
			currently = forecast['currently']
			weather = Weather.new
			current_time = Time.at(currently['time'])

			#convert intensity to rain amount from 9am by summing up the latest 9 hourly precipintesity data
			if Time.now.hour<9
				hour_from_9_am = Time.now.hour + 24 - 9
			else
				hour_from_9_am = Time.now.hour - 9
			end
			total_rain_amount = 0.0
			hourly = forecast['hourly']['data']
			for i in 0..(hour_from_9_am-1)
				total_rain_amount += Float(hourly[i]['precipIntensity'])
			end

			#store other types of data like temperature, source, time and wind
			weather.time = current_time.strftime("%d/%I:%M%p").downcase
			weather.source = 'forecast.io'
			temp = Temperature.new
			temp.current = currently['temperature']
			temp.dew = currently['dewPoint']
			wind = Wind.new
			wind.speed =  (3600*Float(currently['windSpeed'])/1000).to_s
			wind.direction =wind_convert(currently['windBearing'], wind.speed)
			rainfall = Rainfall.new
			rainfall.amount = total_rain_amount
			weather.rainfall = rainfall
			weather.wind = wind
			weather.temperature = temp
			weather.station = db_station
			weather.fetch = Fetch.last
			weather.save
		end
	end

	#make forecast.io wind_direction to be consistent with that in bom
	def wind_convert(wind_bearing, wind_speed)
		begin
			if wind_speed==0
				return 'CALM'
			end
			degree = Float(wind_bearing)
			if degree>348.75 or degree<=11.25
				return 'N'
			elsif degree>11.25 and degree<=33.75
				return 'NNE'
			elsif degree>33.75 and degree<=56.25
				return 'NE'
			elsif degree>56.25 and degree<=78.75
				return 'ENE'
			elsif degree>78.75 and degree<=101.25
				return 'E'
			elsif degree>101.25 and degree<=123.75
				return 'ESE'
			elsif degree>123.75 and degree<=146.25
				return 'SE'
			elsif degree>146.25 and degree<=168.75
				return 'SSE'
			elsif degree>168.75 and degree<=191.25
				return 'S'
			elsif degree>191.25 and degree<=213.75
				return 'SSW'
			elsif degree>213.75 and degree<=236.25
				return 'SW'
			elsif degree>236.25 and degree<=258.75
				return 'WSW'
			elsif degree>258.75 and degree<=281.25
				return 'W'
			elsif degree>281.25 and degree<=303.75
				return 'WNW'
			elsif degree>303.75 and degree<=326.25
				return 'NW'
			elsif degree>326.25 and degree<=348.75
				return 'NNW'
			else
				return 'UNKNOWN DIRECTION'
			end
		rescue
			return 'CALM'
		end
	end

	def data
		#if no data in database yet, fetch for the first time
		if Fetch.all.length==0
			current_fetch_time = DateTime.now
			current_fetch_time -= (current_fetch_time.second).second
			current_fetch_time -= (current_fetch_time.minute%10).minute
			fetch = Fetch.new
			fetch.fetchtime = current_fetch_time
			fetch.save
			retrieve_bom
			retrieve_forecast
			@data_list = Weather.all.to_a
		#else display the data grouped in the last fetch
		else
			@data_list = Weather.where({fetch_id:Fetch.last.id})
		end
	end

end
