require 'wiringpi'
require 'json'

module Garage
  DOOR_PIN = {
    1 => 5,
    2 => 4, 
  }

  def self.gpio
    @gpio ||= WiringPi::GPIO.new
  end

  def self.door(id)
    Door.new id, gpio, DOOR_PIN.fetch(id.to_i)
  end

  class Door
    def initialize(id, gpio, pin)
      @id   = id
      @gpio = gpio
      @pin  = pin
    end

    attr_reader :id, :pin, :gpio

    def value
      gpio.digital_read pin
    end

    def status
      if value == 1
        :closed
      else
        :open
      end
    end

    def to_json
      {
        id: id,
        status: status,
      }.to_json
    end
  end
end
