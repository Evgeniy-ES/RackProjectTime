class TimeFormatter
  AVAILABLE_FORMAT = {"year" => "Y", "month" => "m", "day" => "d", "hour" => "H", "minute" => "M", "second" => "S"}
  UNKNOW_FORMAT = "Unknown time format "

  attr_reader :time_string, :invalid_string


 def initialize
   @time_string = ''
   @invalid_string = ''
 end

  def call(request_with_data)
    time = Time.now
    if request_with_data.empty?
      @time_string = forming_string_with_date(get_keys(AVAILABLE_FORMAT), time)
    else
      record_date_in_string(time, request_with_data)
    end
  end

  def succes?
    @time_string.empty? && @invalid_string.empty? ? false : true
  end

  def record_date_in_string(time, request_with_data)
    array_with_date = request_with_data.split("%2C")
    rezult_string_with_date(array_with_date, time)
  end

  def get_keys(hash)
    (hash.keys + hash.values.grep(Hash){|sub_hash| get_keys(sub_hash)}).flatten
  end

  def rezult_string_with_date(array_with_date, time)
    array_available_format = get_keys(AVAILABLE_FORMAT)
    if (array_with_date - array_available_format).empty?
      @time_string = forming_string_with_date(array_with_date, time)
    else
      array_unknow_date = []
      array_with_date.each do |element_date|
       array_unknow_date << element_date unless array_available_format.include? element_date
      end
      @invalid_string = UNKNOW_FORMAT + array_unknow_date.join(', ')
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
      time.strftime("%#{AVAILABLE_FORMAT[element_date]}")
    else
      string_with_date + "-" + time.strftime("%#{AVAILABLE_FORMAT[element_date]}")
    end
  end

end
