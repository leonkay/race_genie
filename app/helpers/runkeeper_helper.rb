require "rubygems"
require "httparty"
require "sinatra"
require "omniauth-singly"
require 'active_support/all'


def get_user_data()

    puts "Querying for Runkeeper data, :#{RK_SELF} / #{session[:access_token]}"
    raw_data = HTTParty.get("#{RK_SELF}?refresh=true", {
        :query => {:access_token => session[:access_token]}
    })
    # try again
    if raw_data.code == 302
      puts "trying again"
      raw_data = HTTParty.get("#{RK_SELF}?refresh=true", {
          :query => {:access_token => session[:access_token]}
      })
    end

    puts "Raw data #{raw_data}"
    data = raw_data.parsed_response

    puts "Get User Data [#{Time.now}] - [#{data}]"

    name = data[0]["data"]["profile"]["name"]
    avatar = data[0]["data"]["profile"]["normal_picture"]
    gender = data[0]["data"]["profile"]["gender"]
    user = User.new(0, name, avatar, '', gender)
    user
  end

  def get_activities()
    data = HTTParty.get("#{RK_FITNESS}?refresh=true", {
        :query => {:access_token => session[:access_token]}
    }).parsed_response

    activities =  Array.new
    data.each do |activity|
      date = activity["data"]["start_time"].to_time # require active support for this method
      type = activity["data"]["type"]
      distance = activity["data"]["total_distance"] # in meters

      map = { :date => date, :type => type, :distance => distance }

      activities << map
    end
    activities
  end

  def in_progress?
    (start_time..end_time).include?(Time.now)
  end