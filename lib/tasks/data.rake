require 'open-uri'
require 'nokogiri'
require 'json'
require 'whenever'


namespace :data do
	task :fetch => :environment do
		current_fetch_time = DateTime.now
		current_fetch_time -= (current_fetch_time.second).second
		current_fetch_time -= (current_fetch_time.minute%10).minute
		fetch = Fetch.new
		fetch.fetchtime = current_fetch_time
		fetch.save
		WeatherController.new.retrieve_bom
		WeatherController.new.retrieve_forecast
	end

end
