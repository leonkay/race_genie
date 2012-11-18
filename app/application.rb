require "rubygems"
require "httparty"
require "sinatra"
require "json"
require "omniauth-singly"
load 'app/routes/runkeeper.rb'
load 'app/helpers/runkeeper_helper.rb'

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

    # Get User Data
    @user = get_user_data

    # What does Genie Think
    messages = genie_thinks

    erb :main
  else
    erb :home
  end

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

def genie_thinks
  activities = get_activities

  # Get Summary Data
  summarizer = Summarizer.new
  activities.each do |activity|
    summarizer.add_activity(activity)
  end

  summaries = summarizer.summarize

  messages = Array.new
  summaries.each do |summary|
    if summary.lifetime_total < 10000 # 10km
      status = 'A Total Newb'
    elsif summary.lifetime_total < 30000 # 30km
      status = 'A Beginner'
    elsif summary.lifetime_total < 100000 # 100km
      status = 'A Road Warrior'
    else
      status = 'INSANE!'
    end

    pre_msg = "You're a #{summary.activity_type} and #{status}"
    if summary.in_the_past[:month] < 5000
      msg = "#{pre_msg}, but you've been SLACKING!"
    else
      msg = "#{pre_msg} and you've been going strong."
    end

    messages << msg

  end

  messages

end

