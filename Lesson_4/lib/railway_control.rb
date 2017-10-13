=begin
Создать программу в файле main.rb, которая будет позволять пользователю через текстовый интерфейс делать следующее:
  - Создавать станции
  - Создавать поезда
  - Создавать маршруты и управлять станциями в нем (добавлять, удалять)
  - Назначать маршрут поезду
  - Добавлять вагоны к поезду
  - Отцеплять вагоны от поезда
  - Перемещать поезд по маршруту вперед и назад
  - Просматривать список станций и список поездов на станции
=end

require 'cargo_train'
require 'cargo_wagon'

require 'passenger_train'
require 'passenger_wagon'

require 'station'
require 'route'

class RailwayControl

  attr_reader :stations, :routes, :trains
  
  def initialize
    @stations = []
    @routes = []
    @trains = {}
  end

  def create_station(name)
    @stations << Station.new(name)
  end

  def create_train(number)
    @trains[number] = Train.new(number)
  end

  def create_route(first_station, last_station)
    @routes << Route.new(first_station, last_station)
  end

  def add_station_to_route
  end

  def delete_station_from_route
  end

  def set_route
  end

  def add_wagon_to_train(train)
    case train.class
      when 'CargoTrain'
        wagon = CagroWagon.new
      when 'PassengerTrain'
        wagon = PassengerWagon.new
    end

    train.add_wagon wagon
  end

  def delete_wagon_from_train(train)
    train.delete_wagon
  end

  def move_to
  end

  def get_trains
  end

  def get_stations
  end
end
