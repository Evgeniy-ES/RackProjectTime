class App
  NEED_PATH = "/time".freeze
  UNKNOW_FORMAT = "Unknown time format ".freeze
  AVAILABLE_FORMAT = ["year", "month", "day", "hour", "minute", "second"].freeze

  def call(env)
     request_path = env['REQUEST_PATH']
     string_with_date = find_string_with_date(request_path, env)
     [status(string_with_date), headers, body(string_with_date)]
  end

  private

  def find_string_with_date(request_path, env)
    if request_path == NEED_PATH
      request_with_data = env['REQUEST_URI']
      find_date(request_with_data)
   else
     ''
   end
 end

  def find_date(request_with_data)
    time = Time.now
    if check_data(request_with_data) && request_with_data.size > 13
      request_with_data = request_with_data.sub!("/time?format=","")
      array_with_date = request_with_data.split("%2C")
      rezult_string_with_date(array_with_date, time)
    else
      forming_string_with_date(AVAILABLE_FORMAT, time)
    end
  end

  def check_data(request_with_data)
    request_with_data.include? "/time?format="
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
      time.strftime("%#{find_element_date(element_date)}")
    else
      string_with_date + "-" + time.strftime("%#{find_element_date(element_date)}")
    end
  end

  def find_element_date(element_date)
  #  if element_date == "day" || element_date == "month" # Этот коо более короткий но почему то не работал
  #    element_date.first
  #  else
  #    element_date.first.upcase
  #  end
   case element_date
   when 'year'
     'Y'
   when 'month'
     'm'
   when 'day'
     'd'
   when 'hour'
     'H'
   when 'minute'
     'M'
   when 'second'
     'S'
   end
  end

  def status(string_with_date)
    string_with_date == '' ? 404 : find_need_status(string_with_date)
  end

  def find_need_status(string_with_date)
    check_include(string_with_date) ? 400 : 200
  end

  def check_include(string_with_date)
    string_with_date.include? UNKNOW_FORMAT
  end

  def headers
    { 'Content-Type' => 'text/plain' }
  end

  def body(string_with_date)
    [string_with_date]
  end
end
