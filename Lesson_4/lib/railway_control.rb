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

  def create_route(params)
    @routes << Route.new(stations[params[:first_station_index]], stations[params[:last_station_index]])
  end

  def add_station_to_route(params)
    self.routes[params[:route_index]].add_station(stations[params[:station_index]])
  end

  def delete_station_from_route(params)
    self.routes[params[:route_index]].delete_station
  end

  def add_route_to_train(params)
    self.trains[params[:train_number]].route=(routes[params[:route_index]])    
  end

  def add_wagon_to_train(train_number)
    case self.trains[train_number].class
      when 'CargoTrain'
        wagon = CagroWagon.new
      when 'PassengerTrain'
        wagon = PassengerWagon.new
    end

    self.trains[train_number].add_wagon wagon
  end

  def delete_wagon_from_train(train_number)
    self.trains[train_number].delete_wagon
  end

  def move_train_forward(train_number)
    self.trains[train_number].move_forward
  end

  def move_train_backward(train_number)
    self.trains[train_number].move_backward
  end

  def get_trains_on_station(station_index)
    self.stations[station_index].trains
  end

  def get_stations
  end
end
