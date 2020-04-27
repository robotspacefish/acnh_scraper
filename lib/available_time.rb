class AvailableTime
  attr_accessor :time, :start_time, :end_time

  def initialize(time)
    @time = time
    self.set_times
  end

  def self.multiple_times?(time_string)
    time_string.include?('&')
  end

  def self.split_times(time_string, separator )
    time_string.split(separator)
  end

  def set_times
    times = []
    if self.time == "All day"
      times = [0, 23]
    else
      if self.time.include?("am") # formatted like: 4am - 7pm
       self.fix_formatting
      end

      times = AvailableTime.split_times(self.time, " - ").collect do |t|
        hour, meridiem = t.split(" ")

        if meridiem == "PM"
          hour = hour.to_i + 12
        end

        hour.to_i
      end
    end

    self.start_time = times.first
    self.end_time = times.last
  end

  # private
    def fix_formatting
      times = self.time.upcase.split(" - ")

      times = times.collect do |t|
        # start at -3 for index right before am/pm
        t.insert(-3, " ")
      end

      # save newly formatted time
      self.time = times.join(" - ")
    end
end