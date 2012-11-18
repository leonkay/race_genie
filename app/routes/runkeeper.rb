require "rubygems"
require "httparty"
require "sinatra"
require "omniauth-singly"
load "app/model/user.rb"

enable :sessions

RK_SELF = 'https://api.singly.com/services/runkeeper/self'

get "/user" do
  puts "test"
  @data = HTTParty.get(RK_SELF, {
      :query => {:access_token => session[:access_token]}
  }).parsed_response

  name = @data[0]["data"]["profile"]["name"]
  user = User.new(0, name, '')
  content_type :json
  user.to_json

end


get "/events" do

end

get "/metrics" do

end