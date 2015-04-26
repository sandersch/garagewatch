#!/usr/bin/env ruby

require 'sinatra'
require_relative './garage'

class GarageWatch < Sinatra::Application
  get '/door/:id' do
    Garage.door(params[:id]).status.to_s
  end
end
