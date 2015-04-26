#!/usr/bin/env ruby

require 'sinatra'
require_relative './garage'


class GarageWatch < Sinatra::Application
  before do
    content_type :json
  end

  get '/door/:id' do
    Garage.door(params[:id]).to_json
  end

  get '/doors' do
    Garage.status.to_json
  end
end
