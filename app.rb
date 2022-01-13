class App

  NEED_PATH = "/time"
  HEADERS = { 'Content-Type' => 'text/plain' }.freeze

  def call(env)
     request_path = env['REQUEST_PATH']
     request_with_data = env['REQUEST_URI']
     data_with_date = find_string_with_date(request_path, request_with_data)

     response(status(data_with_date), find_body(data_with_date))

  end

  private

  def find_string_with_date(request_path, request_with_data)
    date_object = TimeFormatter.new
    date_object.call(find_format(request_with_data)) if request_path == NEED_PATH
    date_object
  end

  def find_format(request_with_data)
    if request_with_data.include? "/time?format="
      request_with_data = request_with_data.sub!("/time?format=","")
      request_with_data.empty? ? '' : request_with_data
    else
      ''
    end
  end

  def status(date_object)
    date_object.succes? ? find_need_status(date_object) : 404
  end

  def find_need_status(date_object)
    date_object.invalid_string.empty? ? 200 : 400
  end

  def response(status, body_data)
    Rack::Response.new(body_data, status, HEADERS).finish
  end

  def find_body(data_with_date)
    data_with_date.invalid_string.empty? ? data_with_date.time_string : data_with_date.invalid_string
  end

end
