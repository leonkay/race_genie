require 'spreadsheet'
require 'active_support/all'

class Event
  attr_accessor :id, :name, :classification, :activity_type, :date, :time_frame, :image_url, :url, :desc, :difficulty

  #0 - Location, 1-Distance,2-Level of Comp,3-Difficulty Level,4-Time until race,5-Type,6-Name,7-Image,8-Date,9-Description,
  #10-Registration Page,,,
  #Lower Limit,
  #Upper Limit,Level of competitor

  def initialize(id, name, classification, activity_type, date, image_url, url, desc, difficulty) @id = id
  @name = name
  @classification = classification
  @activity_type = activity_type
  @date = date # dates is already a date object!
               #@time_frame = time_frame
  @image_url = image_url
  @url = url
  @desc = desc
  @difficulty = difficulty

  now = Time.now
  one_week = now + 1.week
  one_month = now + 1.month
  three_months = now + 3.months

  if (now..one_week).cover?(@date)
    @time_frame = "1WEEK"
  elsif (now..one_month).cover?(@date)
    @time_frame = "1MONTH"
  elsif (now..three_months).cover?(@date)
    @time_frame = "3MONTHS"
  else @time_frame = "4MONTHS+"
  end
  end
end

class EventReader

  def initialize(xlsx) @events = Array.new

  @easy = Array.new
  @hard = Array.new
  @insanity = Array.new

  count = 0
  #book = Spreadsheet.open xlsx
  #sheet1 = book.worksheet 0

  #sheet1.each do |row| temp = Event.new(count, row[6], row[5], row[5], row[8], row[7], row[10], row[9], row[3])
  #@events << temp

  #if d
  #  count = count + 1
  #end

  puts @events.to_json
  end

#end

  def events(activity_type, difficulty) "stuff"
  end

end