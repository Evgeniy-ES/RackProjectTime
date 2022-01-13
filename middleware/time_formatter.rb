class TimeFormatter
  AVAILABLE_FORMAT = {"year" => "Y", "month" => "m", "day" => "d", "hour" => "H", "minute" => "M", "second" => "S"}
  UNKNOW_FORMAT = "Unknown time format "

  attr_reader :time_string, :invalid_string


 def initialize
   @time_string = []
   @invalid_string = []
 end

  def call(request_with_data)
    if request_with_data.empty?
      rezult_string_with_date(get_keys(AVAILABLE_FORMAT))
    else
      rezult_string_with_date(request_with_data.split("%2C"))
    end
  end

  def success?
    @invalid_string.empty?
  end

  def get_keys(hash)
    (hash.keys + hash.values.grep(Hash){|sub_hash| get_keys(sub_hash)}).flatten
  end

  def rezult_string_with_date(array_with_date)
    array_available_format = get_keys(AVAILABLE_FORMAT)
    time = Time.now
    array_with_date.each do |element_date|
      if array_available_format.include? element_date
        @time_string << time.strftime("%#{AVAILABLE_FORMAT[element_date]}")
      else
        @invalid_string << time.strftime("%#{AVAILABLE_FORMAT[element_date]}")
      end
    end
  end

end
