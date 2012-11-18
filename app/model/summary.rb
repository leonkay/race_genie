require 'active_support/all'

class Summarizer
  @sports
  @past_count
  @total_dist

  def initialize()
    @sports = Set.new # {Running, ...}
    @time_frames = Hash.new {|hash, key| hash[key] = []} # {Running : {week: 1, month: 3, three_months: 4}, Biking : {...}}
    @total_dist = Hash.new  {|hash, key| hash[key] = []}# {Running : {week: 5000, month: 4000, three_months: 3000}, Biking : {...}}
  end

  def add_activity(activity)
    type = activity[:type]
    date = activity[:date]
    dist = activity[:distance]

    unless @sports.include?(type)
      # add the type
      @sports.add(type)
      @time_frames[type] = {:week => 0, :month => 0, :three_months => 0}
      @total_dist[type] = {:week => 0, :month => 0, :three_months => 0}
    end

    time_frame = @time_frames[type]
    distance = @total_dist[type]

    puts "Time Frame #{time_frame}"
    now = Time.now
    one_week_ago = now - 1.week
    one_month_ago = now - 1.month
    three_months_ago = now - 3.months

    if (one_week_ago..now).cover?(date)
      time_frame[:week] = time_frame[:week] + 1
      distance[:week] = distance[:week] + dist
    end

    if (one_month_ago..now).cover?(date)
      time_frame[:month] = time_frame[:month] + 1
      distance[:month] = distance[:month] + dist
    end

    if (three_months_ago..now).cover?(date)
      time_frame[:three_months] = time_frame[:three_months] + 1
      distance[:three_months] = distance[:three_months] + dist
    end

  end

  def summarize
    results = Array.new

    @sports.each do |sport|
      total_dist = 0
      @total_dist[sport].values.each do |dist|
        total_dist = dist + total_dist
      end
      results << Summary.new(sport, @time_frames[sport], @total_dist[sport], total_dist)
    end

    results
  end
end

class Summary
  attr_accessor :activity_type, :in_the_past, :avg_dist_in_the_last, :total_dist, :lifetime_total

  def initialize(sport, time_frame, total_distance, lifetime_total)
    @activity_type = sport
    @in_the_past = time_frame
    @total_dist = total_distance
    @lifetime_total = lifetime_total

    avg_week = 0
    avg_month = 0
    avg_3_months = 0
    if time_frame[:week] > 0
      avg_week = total_distance[:week] / time_frame[:week]
    end

    if time_frame[:month] > 0
      avg_month = total_distance[:month] / time_frame[:month]
    end

    if time_frame[:three_months] > 0
      avg_3_months = total_distance[:three_months] / time_frame[:three_months]
    end

    @avg_dist_in_the_last = {:week => avg_week, :month => avg_month, :three_months => avg_3_months}
  end
end