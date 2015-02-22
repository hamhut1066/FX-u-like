require 'sinatra'
require 'haml'
require 'json'
require 'date'

require_relative 'lib/objects'


post '/' do
  @currencies = ExchangeRate.currencies
  @amount = params['amount'].to_i * ExchangeRate.at(params['date'],params['to'],params['from'])

  begin
    tmp = Date.parse(params['date'])
  rescue ArgumentError, TypeError
    tmp = Date.today
  end
  @to_val = params['to']
  @from_val = params['from']
  @amount_val = params['amount']
  @date = "#{tmp.day}/#{tmp.month}/#{tmp.year}"
  @string = "#{params['from']} => #{params['to']} :"
  haml :index
end


get '/' do
  @currencies = ExchangeRate.currencies
  tmp= Date.today
  @date = "#{tmp.day}/#{tmp.month}/#{tmp.year}"
  haml :index
end

get '/get/currency' do
  ExchangeRate.currencies.to_json
end
