
  def get_user_data()
    @data = HTTParty.get(RK_SELF, {
        :query => {:access_token => session[:access_token]}
    }).parsed_response

    puts @data.to_json
    name = @data[0]["data"]["profile"]["name"]
    avatar = @data[0]["data"]["profile"]["normal_picture"]
    gender = @data[0]["data"]["profile"]["gender"]
    @user = User.new(0, name, avatar, '', gender)
    @user
  end

  def get_activities()
    @data = HTTParty.get(RK_FITNESS, {
        :query => {:access_token => session[:access_token]}
    }).parsed_response

    @activities =  Array.new
    @data.each do |activity|
      date = activity["data"]["start_time"].to_time # require active support for this method
      type = activity["data"]["type"]
      distance = activity["data"]["total_distance"] # in meters

      map = { :date => date, :type => type, :distance => distance }

      @activities << map
    end
    @activities
  end

  def in_progress?
    (start_time..end_time).include?(Time.now)
  end