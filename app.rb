class App

  NEED_PATH = "/time"
  HEADERS = { 'Content-Type' => 'text/plain' }.freeze

  def call(env)
     if env['REQUEST_PATH'] == NEED_PATH
       if_url_correct(env['REQUEST_URI'])
    else
      response(404, "invalid_path")
    end
  end

  private

  def if_url_correct(request_with_data)
    date_object = TimeFormatter.new
    date_object.call(find_format(request_with_data))
    if date_object.success?
      response(200, date_object.time_string.join(', ').gsub(/, /, '-'))
    else
      response(404, UNKNOW_FORMAT + date_object.invalid_string.join(', ').gsub(/, /, '-'))
    end
  end

  def find_format(request_with_data)
    if request_with_data.include? "/time?format="
      request_with_data = request_with_data.sub!("/time?format=","")
    else
      ''
    end
  end

  def response(status, body_data)
    Rack::Response.new(body_data, status, HEADERS).finish
  end

end
