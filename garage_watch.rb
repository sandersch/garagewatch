#!/usr/bin/env ruby

require 'sinatra'
require_relative './garage'

class GarageWatch < Sinatra::Application
  get '/door/:id' do
    Garage.status_of_door(params[:id].to_i).to_s
  end
end
