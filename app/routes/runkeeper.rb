require "rubygems"
require "httparty"
require "sinatra"
require "omniauth-singly"
require "chronic"
require 'active_support/all'

load 'app/helpers/runkeeper_helper.rb'
load 'app/model/user.rb'

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

end

get "/activities" do
  content_type :json
  get_activities.to_json
end

get "/activities/summary" do
  content_type :json
  activities = get_activities

  @sports = Hash.new
  @past_week = 0
  @past_month = 0
  @past_three_months = 0

  now = Time.now
  one_week_ago = now - 1.week
  one_month_ago = now - 1.month
  three_months_ago = now - 3.months

  activities.each do |activity|
    type = activity[:type]
    date = activity[:date]

    if (one_week_ago..now).cover?(date)
      @past_week = @past_week + 1
    end

    if (one_month_ago..now).cover?(date)
      @past_month = @past_month + 1
    end

    if (three_months_ago..now).cover?(date)
      @past_three_months = @past_three_months + 1
    end

    type_data = @sports[type]
    if type_data.nil?
      @sports[type] = {:count => 0}
    else
      count = type_data[:count] + 1
      type_data[:count] = count
      @sports[type] = type_data
    end

    @sports[type][:past_week] = @past_week
    @sports[type][:past_month] = @past_month
    @sports[type][:past_three_months] = @past_three_months


  end


  @sports.to_json
end

