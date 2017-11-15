require_relative 'manufactura'
require_relative 'validation'

class Train
  include Manufactura
  include Validation

  TYPES = [
    {
      type: 'CargoTrain',
      name: 'Грузовой'
    },
    {
      type: 'PassengerTrain',
      name: 'Пассажирский'
    }
  ].freeze

  @@trains = {}

  attr_reader :speed, :number, :current_station_index, :route, :wagons

  validate :number, :format, /^[a-zа-я\d]{3}-?[a-zа-я\d]{2}$/i, message: 'Неверный формат. Попробуйте ввести другой номер.'

  def initialize(number)
    @number = number
    @speed = 0
    @wagons = []
    @route = nil
    @current_station_index = nil
    @@trains[number] = self
    validate!
  end

  def type
    Train::TYPES.select { |type| type[:type] == self.class.to_s }
  end

  def each_wagon
    wagons.each { |wagon| yield(wagon) } if block_given?
  end

  def self.find(train_number)
    @@trains[train_number]
  end

  def speed_up(n)
    @speed += n
  end

  def speed_down(n)
    @speed = speed - n >= 0 ? speed - n : stop
  end

  def stop
    @speed = 0
  end

  def to_s
    "Поезд '№#{number}' тип '#{self.class}' вагонов '#{wagons_count}'"
  end

  def add_wagon(wagon)
    raise StandardError, 'Нельзя прицепить: поезд движется' if speed > 0

    @wagons << wagon
  end

  def delete_wagon
    raise StandardError, 'У поезда нет прицепленных вагонов' if wagons_count.zero?
    raise StandardError, 'Нельзя отцепить: поезд движется' if speed > 0

    @wagons.pop
  end

  def wagons_count
    wagons.length
  end

  def route=(route)
    raise StandardError, 'Аргумент не является типом Route' unless route.is_a?(Route)

    @route = route
    @current_station_index = 0
    current_station.place_train(self)
  end

  def current_station
    station(current_station_index)
  end

  def previous_station
    station(current_station_index - 1)
  end

  def next_station
    station(current_station_index + 1)
  end

  def move_forward
    raise StandardError, 'Это конечная станция' unless next_station

    move(current_station_index + 1)
  end

  def move_backward
    raise StandardError, 'Это начальная станция' unless previous_station

    move(current_station_index - 1)
  end

  protected

  def move(n)
    current_station.send_train(number)
    @current_station_index = n
    current_station.place_train(self)
  end

  def station(n)
    n >= 0 && n < route.stations.length ? route.stations[n] : nil
  end
end
