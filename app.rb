require 'bundler/inline'
require 'date'

gemfile do
  source 'https://rubygems.org'
  gem 'faraday'
  gem 'dotenv', require: 'dotenv/load'
end

def check_environment_variables
  %w/GITHUB_USERNAME HABITRA_ID HABITRA_PASSWORD HABITRA_HABIT_ID/.each do |environment_variable_name|
    raise "Missing required environment variable #{environment_variable_name}" if ENV[environment_variable_name].to_s.empty?
  end
end

def fetch_contributions(username)
  url = "https://github-contributions-api.deno.dev/#{username}.json?flat=true"
  res = Faraday.get(url)
  json = JSON.parse(res.body, symbolize_names: true)

  Hash[json[:contributions].map { |contribution| [contribution[:date], contribution[:contributionCount]] }]
end

def track_habit(user_id, user_password, habit_id, date)
  url = "https://api.habitra.io/v1/users/#{user_id}/habits/#{habit_id}/tracks"
  headers = { 'Authorization' => "Basic #{Base64.encode64("#{user_id}:#{user_password}")}" }
  res = Faraday.post(url, { date: }.to_json, headers)

  puts JSON.parse(res.body, symbolize_names: true)[:message]
end

check_environment_variables

contributions = fetch_contributions(ENV['GITHUB_USERNAME'])

today = Date.today

(today-1..today).map(&:to_s).each do |date|
  track_habit(ENV['HABITRA_ID'], ENV['HABITRA_PASSWORD'], ENV['HABITRA_HABIT_ID'], date) if contributions[date].positive?
end
