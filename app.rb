require 'sinatra'
require 'haml'
require 'json'
require 'date'

require_relative 'lib/objects'


post '/' do
  @currencies = ExchangeRate.currencies
  @amount = params['amount'].to_i * ExchangeRate.at(params['date'],params['to'],params['from'])
  tmp= Date.today
  @date = "#{tmp.day}/#{tmp.month}/#{tmp.year}"
  @string = "#{params['to']} => #{params['from']} :"
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
