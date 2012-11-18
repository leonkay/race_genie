require "rubygems"
require "httparty"
require "sinatra"
require "omniauth-singly"
load "app/model/user.rb"

enable :sessions

RK_ROOT = 'https://api.singly.com/services/runkeeper'
RK_SELF = "#{RK_ROOT}/self"
RK_FITNESS = "#{RK_ROOT}/fitness_activities"

get "/user" do
  puts "test"
  @data = HTTParty.get(RK_SELF, {
      :query => {:access_token => session[:access_token]}
  }).parsed_response

  name = @data[0]["data"]["profile"]["name"]
  avatar = @data[0]["data"]["profile"]["normal_picture"]
  gender = @data[0]["data"]["profile"]["gender"]
  user = User.new(0, name, avatar, '', gender)
  content_type :json
  user.to_json

end


get "/events" do

end

get "/metrics" do

end