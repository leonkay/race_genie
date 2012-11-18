require "rubygems"
require "httparty"
require "sinatra"
require "omniauth-singly"
require 'active_support/all'

load 'app/helpers/runkeeper_helper.rb'
load 'app/model/user.rb'
load 'app/model/summary.rb'
load 'app/model/event.rb'

enable :sessions

RK_ROOT = 'https://api.singly.com/services/runkeeper'
RK_SELF = "#{RK_ROOT}/self"
RK_FITNESS = "#{RK_ROOT}/fitness_activities"

get "/user" do
  content_type :json
  get_user_data.to_json
end


get "/events" do
  content_type :json

  level = params[:type]
  puts "Using Level #{level}"

  reader = EventReader.new('app/public/Races.xls')
  reader.events("RUNNING", level)
end

get "/activities" do
  content_type :json
  get_activities.to_json
end

get "/activities/summary" do
  content_type :json
  activities = get_activities

  @summarizer = Summarizer.new
  activities.each do |activity|
    @summarizer.add_activity(activity)
  end

  @summarizer.summarize.to_json
end

