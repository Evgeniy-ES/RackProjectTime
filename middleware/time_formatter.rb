class TimeFormatter
  AVAILABLE_FORMAT = {"year" => "Y", "month" => "m", "day" => "d", "hour" => "H", "minute" => "M", "second" => "S"}

 attr_reader :invalid_string

 def initialize
   @time_string = []
   @invalid_string = []
 end

  def call(request_with_data)
    array_available_format = AVAILABLE_FORMAT.keys
    request_with_data.each do |element_date|
      if array_available_format.include? element_date
        @time_string << AVAILABLE_FORMAT[element_date]
      else
        @invalid_string << element_date
      end
    end
  end

  def success?
    @invalid_string.empty?
  end

  def time_string
    Time.now.strftime("%" + @time_string.join('-%')) if @time_string.present?
  end

end
