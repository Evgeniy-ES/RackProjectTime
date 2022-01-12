class App

  UNKNOW_FORMAT = "Unknown time format ".freeze
  HEADERS = { 'Content-Type' => 'text/plain' }.freeze

  def call(env)
     request_path = env['REQUEST_PATH']
     request_with_data = env['REQUEST_URI']

     date_object = TimeFormatter.new
     string_with_date = date_object.find_string_with_date(request_path, request_with_data)

     response(status(string_with_date), string_with_date)
     #[status(string_with_date), headers, body(string_with_date)]
  end

  private

  def status(string_with_date)
    string_with_date == '' ? 404 : find_need_status(string_with_date)
  end

  def find_need_status(string_with_date)
    check_include(string_with_date) ? 400 : 200
  end

  def check_include(string_with_date)
    string_with_date.include? UNKNOW_FORMAT
  end

  def response(status, body_data)
    Rack::Response.new(body_data, status, HEADERS).finish
  end
end
