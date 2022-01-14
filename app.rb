class App

  NEED_PATH = "/time"
  HEADERS = { 'Content-Type' => 'text/plain' }.freeze
  UNKNOW_FORMAT = "Unknown time format "

  def call(env)
     if env['REQUEST_PATH'] == NEED_PATH
       if_url_correct(env)
    else
      response(404, "invalid_path")
    end
  end

  private

  def if_url_correct(env)
    request = Rack::Request.new(env)
    date_object = TimeFormatter.new
    date_object.call(request.params['format'].split(","))
    if date_object.success?
      response(200, date_object.time_string)
    else
      response(404, UNKNOW_FORMAT + date_object.invalid_string.join(', '))
    end
  end

  def response(status, body_data)
    Rack::Response.new(body_data, status, HEADERS).finish
  end
end
