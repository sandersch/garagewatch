#!/usr/bin/env ruby

require 'sinatra'
require_relative './garage'


class GarageWatch < Sinatra::Application
  # api
  before do
    content_type :json
  end

  get '/door/:id' do
    Garage.door(params[:id]).to_json
  end

  get '/doors' do
    Garage.status.to_json
  end

  put '/door/:id' do
    begin
      payload = JSON.parse(request.body.read)

      Garage.door(params[:id]).update(payload['position'])
    rescue JSON::ParserError => e
      [ 400 ]
    end
  end

  # front end
  set :public_folder, '../garage-fe/'

  get '/' do
    content_type :html
    send_file File.join %w(.. garage-fe index.html)
  end
end
