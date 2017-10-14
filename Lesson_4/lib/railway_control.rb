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
    return if Train::TYPES[type_index].nil?

    number = gets_train_number
    clear_screen
    return if number.empty?

    case Train::TYPES[type_index][:type]
      when 'CargoTrain'
        train = CargoTrain.new(number)
      when 'PassengerTrain'
        train = PassengerTrain.new(number)
      else
        puts "неизвестный тип поезда"
        return nil
    end
    
    @trains << train
  end

  def create_route
    return if self.stations.length < 2
    
    self.print_stations
    print "Введите индекс начальной станции: "
    first_station_index = gets.chomp.to_i
    print "Введите индекс конечной станции: "
    last_station_index = gets.chomp.to_i
    
    clear_screen
    unless self.stations[first_station_index].nil? && self.stations[last_station_index].nil?
      @routes << Route.new(self.stations[first_station_index], self.stations[last_station_index])
    end
  end

  def add_station_to_route
    return if self.routes.empty? || self.stations.empty?

    self.print_stations
    station_index = gets_station_index
    clear_screen

    self.print_routes
    route_index = gets_route_index
    clear_screen

    unless self.routes[route_index].nil? && stations[station_index].nil?
      self.routes[route_index].add_station(stations[station_index])
    end
  end

  def delete_station_from_route
    return if self.routes.empty? || self.stations.empty?

    self.print_routes
    route_index = gets_route_index
    clear_screen

    self.routes[route_index].delete_station unless self.routes[route_index].nil?
  end

  def add_route_to_train
    return if self.trains.empty? || self.routes.empty?

    self.print_routes
    route_index = gets_route_index
    clear_screen

    self.print_all_trains
    train_index = gets_train_index
    clear_screen

    unless self.trains[train_index].nil? && self.routes[route_index].nil? 
      self.trains[train_index].route=(self.routes[route_index])    
    end
  end

  def add_wagon_to_train
    return if self.trains.empty?

    self.print_all_trains
    train_index = gets_train_index
    clear_screen

    unless self.trains[train_index].nil?
      case self.trains[train_index].class.to_s
        when 'CargoTrain'
          wagon = CargoWagon.new
        when 'PassengerTrain'
          wagon = PassengerWagon.new
      end

      self.trains[train_index].add_wagon wagon
    end
  end

  def delete_wagon_from_train
    return if self.trains.empty?

    self.print_all_trains
    train_index = gets_train_index
    clear_screen

    self.trains[train_index].delete_wagon unless self.trains[train_index].nil?
  end

  def move_train_forward
    return if self.trains.empty? || self.stations.empty? || self.routes.empty?

    self.print_all_trains
    train_index = gets_train_index
    clear_screen

    unless self.trains[train_index].route.nil? || self.trains[train_index].nil?
      self.trains[train_index].move_forward
    end
  end

  def move_train_backward
    return if self.trains.empty? || self.stations.empty? || self.routes.empty?

    self.print_all_trains
    train_index = gets_train_index
    clear_screen

    unless self.trains[train_index].route.nil? || self.trains[train_index].nil?
      self.trains[train_index].move_backward
    end
  end

  def print_trains_on_station
    return if self.trains.empty? || self.stations.empty?

    self.print_stations
    station_index = gets_station_index
    clear_screen

    unless self.stations[station_index].nil?
      trains = [] 
      self.stations[station_index].trains.each { |number, train| trains << train }
      print_trains(trains)
    end
    print_separator
  end
  
  def print_stations
    self.stations.each_with_index do |station, index|
      puts "[#{index}] #{station.name}"
    end 
    print_separator
  end

  def print_routes
    self.routes.each_with_index do |route, index|
      print "[#{index}] ["
      route.stations.each { |station| print " \"#{station.name}\" " }
      puts "]"
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
    puts
    puts "Для продолжения нажмите Enter..."
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
    gets.chomp.to_i
  end

  def gets_station_name
    print "Введите название станции: "
    station_name = gets.chomp.lstrip
  end

  def gets_station_index
    print "Введите индекс станции: "
    station_index = gets.chomp.to_i
  end

  def gets_train_number
    print "Задайте номер поезда: "
    gets.chomp.lstrip
  end

  def gets_train_index
    print "Введите индекс поезда: "
    train_index = gets.chomp.to_i
  end

  def gets_route_index
    print "Введите индекс маршрута: "
    route_index = gets.chomp.to_i
  end

  def print_trains(trains)
    trains.each_with_index do |train, index|
      train_type = train.class.to_s
      type = Train::TYPES.select { |train| train[:type] == train_type; }
      print "[#{index}] Поезд №#{train.number} | "
      print "Тип: #{type[0][:name]} | "
      print "Вагонов: #{train.wagons_count} | "
      print "Текущая станция: #{train.current_station.name}" unless train.route.nil?
      puts
    end
  end

  def print_separator
    puts "---"
  end

end
