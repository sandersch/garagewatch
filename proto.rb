#!/usr/bin/env ruby

require 'wiringpi'
require 'sinatra'

module Garage
  extend self

  DOOR_PIN = {
    1 => 5,
    2 => 4, 
  }

  def gpio
    @gpio ||= WiringPi::GPIO.new
  end

  def value_of_door(num)
    gpio.digital_read DOOR_PIN.fetch(num)
  end

  def status_from_value(value)
    if value == 1
      :closed
    else
      :open
    end
  end

  def status_of_door(num)
    status_from_value value_of_door(num)
  end
end

get '/door/:id' do
  Garage.status_of_door(params[:id].to_i).to_s
end
