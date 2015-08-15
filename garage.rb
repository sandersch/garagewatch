require 'wiringpi'
require 'json'

module Garage
  DOOR_PIN = {
    1 => { in: 5, out: 3 },
    2 => { in: 4, out: 0 },
  }

  def self.gpio
    @gpio ||= WiringPi::GPIO.new
  end

  def self.door(id)
    Door.new id, gpio, DOOR_PIN.fetch(id.to_i)
  end

  def self.status
    {
      doors: DOOR_PIN.map do |(id, pins)|
        Door.new(id, gpio, pins)
      end
    }
  end

  class Door
    def initialize(id, gpio, pins)
      @id      = id
      @gpio    = gpio
      @in_pin  = pins.fetch(:in)
      @out_pin = pins.fetch(:out)
    end

    attr_reader :id, :in_pin, :out_pin, :gpio

    def value
      gpio.digital_read in_pin
    end

    def status
      if value == 1
        :closed
      else
        :open
      end
    end

    def to_json(*)
      to_hash.to_json
    end

    def to_hash(*)
      {
        id: id,
        status: status,
      }
    end

    def update(position)
      if (validator = PositionValidator.new position).valid?
        [ 200, { door: to_hash.merge(status: set(position))}.to_json ]
      else
        [ 422, { errors: validator.errors }.to_json ]
      end
    end

    private

    def move
      gpio.pin_mode out_pin, WiringPi::OUTPUT
      sleep 0.25
      gpio.pin_mode out_pin, WiringPi::INPUT
    end

    def set(position)
      if status.to_s == position
        status
      else
        move
        :moving
      end
    end

  end

  class PositionValidator
    VALID_POSITIONS = %w(open closed)

    def initialize(position)
      @position = position
    end

    attr_reader :position, :errors

    def validate
      @errors = []
      validate_recognized_position
      @errors
    end

    def validate_recognized_position
      unless VALID_POSITIONS.include? position.to_s
        @errors << { :position => "not in #{VALID_POSITIONS.join(', ')}" }
      end
    end

    def valid?
      validate && errors.none?
    end
  end
end
