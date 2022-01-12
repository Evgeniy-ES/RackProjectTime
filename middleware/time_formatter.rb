class TimeFormatter
  AVAILABLE_FORMAT = ["year", "month", "day", "hour", "minute", "second"]
  HASH_WITH_DATE = {"year" => "Y", "month" => "m", "day" => "d", "hour" => "H", "minute" => "M", "second" => "S"}
  NEED_PATH = "/time"
  UNKNOW_FORMAT = "Unknown time format "

  def find_string_with_date(request_path, request_with_data)
    if request_path == NEED_PATH
      find_date(request_with_data)
   else
     ''
   end
 end

  def find_date(request_with_data)
    time = Time.now
    if request_with_data.include? "/time?format="
      request_with_data = request_with_data.sub!("/time?format=","")
      request_with_data.nil? ? forming_string_with_date(AVAILABLE_FORMAT, time) : record_date_in_string(time, request_with_data)
    else
      forming_string_with_date(AVAILABLE_FORMAT, time)
    end
  end

  def record_date_in_string(time, request_with_data)
    array_with_date = request_with_data.split("%2C")
    rezult_string_with_date(array_with_date, time)
  end

  def rezult_string_with_date(array_with_date, time)
    if (array_with_date - AVAILABLE_FORMAT).empty?
      forming_string_with_date(array_with_date, time)
    else
      array_unknow_date = []
      array_with_date.each do |element_date|
       array_unknow_date << element_date unless AVAILABLE_FORMAT.include? element_date
      end
      UNKNOW_FORMAT + array_unknow_date.join(', ')
    end
  end

  def forming_string_with_date(array_date, time)
    string_with_date = nil
    array_date.each do |element_date|
      string_with_date = record_date(string_with_date, time, element_date)
    end
    string_with_date
  end

  def record_date(string_with_date, time, element_date)
    if string_with_date.nil?
      time.strftime("%#{HASH_WITH_DATE[element_date]}")
    else
      string_with_date + "-" + time.strftime("%#{HASH_WITH_DATE[element_date]}")
    end
  end

end
