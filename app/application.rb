require "rubygems"
require "httparty"
require "sinatra"
require "json"
require "omniauth-singly"
load 'app/routes/runkeeper.rb'

class Event
  attr_accessor :name 
  def initialize(name)
    @name = name
  end

end

class Sport
  attr_accessor :name ,:events
  
  def initialize(name, events)
    @name = name
    @events = events
  end

end

RK_SELF = 'https://api.singly.com/services/runkeeper/self'


SINGLY_API_BASE = "https://api.singly.com"
SINGLY_ID = "b6bec79037046c1acadbe7f3dc8077fb"
SINGLY_SECRET = "5eb4bba7309db6ba8ad7610e5fb02c9b"

enable :sessions

use OmniAuth::Builder do
  provider :singly, SINGLY_ID, SINGLY_SECRET
end

get "/" do
  if session[:access_token]
    @profiles = HTTParty.get(profiles_url, {
                  :query => {:access_token => session[:access_token]}
                }).parsed_response
  end
  erb :index
end

get "/auth/singly/callback" do
  auth = request.env["omniauth.auth"]
  session[:access_token] = auth.credentials.token
  redirect "/"
end

get "/logout" do
  session.clear
  redirect "/"
end

get '/genie' do
=begin
  event1 = Event.new("Event 1")
  event2 = Event.new("Event 2")
  event3 = Event.new("Event 3")
  event4 = Event.new("Event 4")
  event5 = Event.new("Event 5")
  event6 = Event.new("Event 6")


  running_events = [event1,event2,event3]
  running = Sport.new("running", running_events)

  biking_events = [event4,event5,event6]
  biking = Sport.new("biking", biking_events)  

  @sports = [running, biking]
=end

  erb :genie
end

def profiles_url
  "#{SINGLY_API_BASE}/profiles"
end

