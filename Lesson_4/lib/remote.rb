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

class Remote
  
  def create_station
  end

  def create_train
  end

  def create_route
  end

  def add_station
  end

  def delete_station
  end

  def set_route
  end

  def add_wagon
  end

  def delete_wagon
  end

  def move_to
  end

  def get_trains
  end

  def get_stations
  end
end
