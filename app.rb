require 'bundler/inline'

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

def fetch_last_contribution_date(username)
  url = "https://github-contributions-api.deno.dev/#{username}.json?flat=true"
  res = Faraday.get(url)
  json = JSON.parse(res.body, symbolize_names: true)

  json[:contributions].last[:date]
end

def track_habit(user_id, user_password, habit_id)
  url = "https://api.habitra.io/v1/users/#{user_id}/habits/#{habit_id}/tracks"
  headers = { 'Authorization' => "Basic #{Base64.encode64("#{user_id}:#{user_password}")}" }
  res = Faraday.post(url, nil, headers)

  puts JSON.parse(res.body, symbolize_names: true)[:message]
end

check_environment_variables

last_contribution_date = fetch_last_contribution_date(ENV['GITHUB_USERNAME'])
today = Time.now.strftime('%Y-%m-%d')

track_habit(ENV['HABITRA_ID'], ENV['HABITRA_PASSWORD'], ENV['HABITRA_HABIT_ID']) if last_contribution_date == today
