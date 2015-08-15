#!/usr/bin/env ruby

require 'sinatra'
require_relative './garage'

class GarageWatch < Sinatra::Application
  # api
  before do
    content_type :json
    response['Access-Control-Allow-Origin'] = '*'
  end

  get '/doors/:id' do
    begin
      { door: Garage.door(params[:id])}.to_json
    rescue KeyError
      [ 404 ]
    end
  end

  get '/doors' do
    Garage.status.to_json
  end

  put '/doors/:id' do
    begin
      payload = JSON.parse(request.body.read)
      payload = payload['door'] if payload['door']

      Garage.door(params[:id]).update(payload['status'])
    rescue JSON::ParserError => e
      [ 400 ]
    rescue KeyError
      [ 404 ]
    end
  end

  # front end
  set :public_folder, '../garage-fe/'

  get '/' do
    content_type :html
    send_file File.join %w(.. garage-fe index.html)
  end
end
