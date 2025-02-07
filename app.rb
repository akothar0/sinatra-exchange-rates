require "sinatra"
require "sinatra/reloader"
require "dotenv/load"
require "http"
exchange_api_key = ENV.fetch("EXCHANGE_RATE_KEY")

get("/") do
  exchange_url = "https://api.exchangerate.host/list?access_key=" + exchange_api_key
  raw_response = HTTP.get(exchange_url)
  parsed_response = JSON.parse(raw_response)
  @currencies = pp parsed_response["currencies"].keys
  erb(:homepage)
end

get("/:currency") do
  exchange_url = "https://api.exchangerate.host/list?access_key=" + exchange_api_key
  raw_response = HTTP.get(exchange_url)
  parsed_response = JSON.parse(raw_response)
  @currencies = pp parsed_response["currencies"].keys
  @first_currency = params.fetch("currency").to_s
  erb(:convert_to)
end

get("/:first_currency/:second_currency") do
  @first_currency = params.fetch("first_currency").to_s
  @second_currency = params.fetch("second_currency").to_s
  conversion_url = "https://api.exchangerate.host/convert?from=" + @first_currency + "&to=" + @second_currency + "&amount=1&access_key=" + exchange_api_key
  conversion_url_response = HTTP.get(conversion_url)
  parsed_conversion_response = JSON.parse(conversion_url_response)
  @exchange_rate = parsed_conversion_response["result"]
  erb(:exchange)
end
