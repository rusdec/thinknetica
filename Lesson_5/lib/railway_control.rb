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

require_relative 'cargo_train'
require_relative 'cargo_wagon'

require_relative 'passenger_train'
require_relative 'passenger_wagon'

require_relative 'station'
require_relative 'route'

require_relative 'railway_statistic'

class RailwayControl

  attr_reader :stations, :routes, :trains, :statistic
  
  def initialize
    @stations = []
    @routes = []
    @trains = []
    @statistic = RailwayStatistic.new
  end

  def create_station
    station_name = gets_station_name
    @stations << Station.new(station_name) unless station_name.empty?
    clear_screen
  end

  def create_train
    Train::TYPES.each_with_index do |train_type, index|
      puts "[#{index}] #{train_type[:name]}"
    end

    type_index = gets_train_type_index
    clear_screen
    return if type_index.nil? || Train::TYPES[type_index].nil?

    number = gets_train_number
    clear_screen
    return if number.empty?

    case Train::TYPES[type_index][:type]
      when 'CargoTrain' then train = CargoTrain.new(number)
      when 'PassengerTrain' then train = PassengerTrain.new(number)
      else return 
    end
    
    @trains << train
  end

  def create_route
    return if self.stations.length < 2
    
    self.print_stations
    first_station_index = gets_first_station_index
    last_station_index = gets_last_station_index
    clear_screen
    
    return if first_station_index.nil? || self.stations[first_station_index].nil?
    return if last_station_index.nil? || self.stations[last_station_index].nil?

    @routes << Route.new(self.stations[first_station_index], self.stations[last_station_index])
  end

  def add_station_to_route
    return if self.routes.empty?

    self.print_stations
    station_index = gets_station_index
    clear_screen
    return if station_index.nil? || self.stations[station_index].nil?

    self.print_routes
    route_index = gets_route_index
    clear_screen
    return if route_index.nil? || self.routes[route_index].nil?

    self.routes[route_index].add_station(stations[station_index])
  end

  def delete_station_from_route
    return if self.routes.empty?

    self.print_routes
    route_index = gets_route_index
    clear_screen
    return if route_index.nil? || self.routes[route_index].nil?

    self.routes[route_index].delete_station
  end

  def add_route_to_train
    return if self.trains.empty? || self.routes.empty?

    self.print_routes
    route_index = gets_route_index
    clear_screen
    return if route_index.nil? || self.routes[route_index].nil?

    self.print_all_trains
    train_index = gets_train_index
    clear_screen
    return if train_index.nil? || self.trains[train_index].nil?
    
    self.trains[train_index].route=(self.routes[route_index])    
  end

  def add_wagon_to_train
    return if self.trains.empty?

    self.print_all_trains
    train_index = gets_train_index
    clear_screen

    return if self.trains[train_index].nil?

    case self.trains[train_index].class.to_s
      when 'CargoTrain' then wagon = CargoWagon.new
      when 'PassengerTrain' then wagon = PassengerWagon.new
      else return
    end

    self.trains[train_index].add_wagon wagon
  end

  def delete_wagon_from_train
    return if self.trains.empty?

    self.print_all_trains
    train_index = gets_train_index
    clear_screen
    return if train_index.nil? || self.trains[train_index].nil?
    
    self.trains[train_index].delete_wagon
  end

  def move_train_forward
    return if self.trains.empty? || self.routes.empty?

    self.print_all_trains
    train_index = gets_train_index
    clear_screen
    return if train_index.nil? || self.trains[train_index].nil?

    return if self.trains[train_index].route.nil?

    self.trains[train_index].move_forward
  end

  def move_train_backward
    return if self.trains.empty? || self.routes.empty?

    self.print_all_trains
    train_index = gets_train_index
    clear_screen
    return if train_index.nil? || self.trains[train_index].nil?

    return if self.trains[train_index].route.nil?

    self.trains[train_index].move_backward
  end

  def print_trains_on_station
    return if self.trains.empty? || self.stations.empty?

    self.print_stations
    station_index = gets_station_index
    clear_screen
    return if station_index.nil? || self.stations[station_index].nil?

    trains = [] 
    self.stations[station_index].trains.each { |number, train| trains << train }
    print_trains(trains)

    print_separator
  end
  
  def print_stations
    self.stations.each_with_index { |station, index| puts "[#{index}] #{station.name}" }
    print_separator
  end

  def print_routes
    self.routes.each_with_index do |route, index|
      stations = []
      route.stations.each { |station| stations << station.name }
      puts "[#{index}] #{stations.join(" -> ")}"
    end  
    print_separator
  end

  def print_all_trains
    print_trains(self.trains)
    print_separator
  end

  def clear_screen
    print "\e[2J\e[f"
  end

  def print_short_statistic
    self.statistic.calculate_short_statistic(current_state_data)
    self.statistic.print_short_statistic
  end

  def print_extended_statistic
    self.statistic.calculate_extended_statistic(current_state_data)
    self.statistic.print_extended_statistic
    print "Для продолжения нажмите Enter..."
    gets
    clear_screen
  end

  private

  def current_state_data
    {
      trains: self.trains,
      routes: self.routes,
      stations: self.stations
    } 
  end

  def gets_train_type_index
    print "Введите индекс типа поезда: "
    gets_integer
  end

  def gets_first_station_index
    print "Введите индекс начальной станции: "
    gets_integer
  end
  
  def gets_last_station_index
    print "Введите индекс конечной станции: "
    gets_integer
  end

  def gets_station_name
    print "Введите название станции: "
    gets.chomp.lstrip.rstrip
  end

  def gets_station_index
    print "Введите индекс станции: "
    gets_integer
  end

  def gets_train_number
    print "Задайте номер поезда: "
    gets.chomp.lstrip.rstrip
  end

  def gets_train_index
    print "Введите индекс поезда: "
    gets_integer
  end

  def gets_route_index
    print "Введите индекс маршрута: "
    gets_integer
  end

  def gets_integer
    input = gets.chomp.lstrip.rstrip
    return (input.empty? || /\D/.match(input)) ? nil : input.to_i
  end

  def print_trains(trains)
    trains.each_with_index do |train, index|
      train_type = train.class.to_s
      type = Train::TYPES.select { |train| train[:type] == train_type }
      printable_data = [
        "[#{index}] Поезд №#{train.number}",
        "Тип: #{type[0][:name]}",
        "Вагонов: #{train.wagons_count}",
      ]
      printable_data << "Текущая станция: #{train.current_station.name}" unless train.route.nil?
      puts printable_data.join(" | ")
    end
  end

  def print_separator
    puts "---"
  end

end
