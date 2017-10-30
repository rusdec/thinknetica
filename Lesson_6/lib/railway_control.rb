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
    station = Station.new(station_name)

    @stations << station
    "Станция '#{station_name}' создана"
  end

  def create_train
    Train::TYPES.each_with_index do |train_type, index|
      puts "[#{index}] #{train_type[:name]}"
    end
    type_index = gets_train_type_index
    validate!(type_index, Train::TYPES)

    number = gets_train_number
    case Train::TYPES[type_index][:type]
      when 'CargoTrain' then train = CargoTrain.new(number)
      when 'PassengerTrain' then train = PassengerTrain.new(number)
    end
    rescue StandardError => error
      clear_screen
      puts error 
      retry
    else
      @trains << train
      "Поезд '№#{number}' тип '#{Train::TYPES[type_index][:name]}' создан"
  end

  def create_route
    return if self.stations.length < 2
    
    self.print_stations

    first_station_index = gets_first_station_index
    validate!(first_station_index, self.stations)

    last_station_index = gets_last_station_index
    validate!(last_station_index, self.stations)
      
    self.routes << Route.new(self.stations[first_station_index], self.stations[last_station_index])
    "Маршрут '#{self.stations[first_station_index].name} -> #{self.stations[last_station_index].name}' создан"
  end

  def add_station_to_route
    return if self.routes.empty?

    self.print_stations
    station_index = gets_station_index

    self.print_routes
    route_index = gets_route_index

    validate!(station_index, self.stations)
    validate!(route_index, self.routes)

    self.routes[route_index].add_station(stations[station_index])
    "Станция '#{stations[station_index].name}' добавлена в маршрут"
  end

  def delete_station_from_route
    return if self.routes.empty?

    self.print_routes
    route_index = gets_route_index
    validate!(route_index, self.routes)

    station_name = self.routes[route_index].stations[-2].name
    self.routes[route_index].delete_station
    "Станция '#{station_name}' удалена из маршрута"
  end

  def add_route_to_train
    return if self.trains.empty? || self.routes.empty?

    self.print_routes
    route_index = gets_route_index

    self.print_all_trains
    train_index = gets_train_index

    validate!(route_index, self.routes)
    validate!(train_index, self.trains)
    
    self.trains[train_index].route=(self.routes[route_index])    
    "Маршрут добавлен к поезду №#{self.trains[train_index].number}"
  end

  def add_wagon_to_train
    return if self.trains.empty?

    self.print_all_trains
    train_index = gets_train_index
    validate!(train_index, self.trains)

    case self.trains[train_index].class.to_s
      when 'CargoTrain' then wagon = CargoWagon.new
      when 'PassengerTrain' then wagon = PassengerWagon.new
    end

    self.trains[train_index].add_wagon wagon
    "Вагон добавлен к поезду №#{self.trains[train_index].number}"
  end

  def delete_wagon_from_train
    return if self.trains.empty?

    self.print_all_trains
    train_index = gets_train_index
    validate!(train_index, self.trains)
    
    self.trains[train_index].delete_wagon
    "Вагон отцеплен от поезда №#{self.trains[train_index].number}"
  end

  def move_train_forward
    return if self.trains.empty? || self.routes.empty?

    self.print_all_trains
    train_index = gets_train_index
    validate!(train_index, self.trains)

    if self.trains[train_index].route.nil?
      "У поезда №#{self.trains[train_index].number} нет маршрута"
    else
      self.trains[train_index].move_forward
      "Поезд №#{self.trains[train_index].number} прибыл на станцию '#{self.trains[train_index].current_station.name}'"
    end
  end

  def move_train_backward
    return if self.trains.empty? || self.routes.empty?

    self.print_all_trains
    train_index = gets_train_index
    validate!(train_index, self.trains)

    if self.trains[train_index].route.nil?
      "У поезда №#{self.trains[train_index].number} нет маршрута"
    else
      self.trains[train_index].move_backward
      "Поезд №#{self.trains[train_index].number} прибыл на станцию '#{self.trains[train_index].current    _station.name}'"
    end
  end

  def print_trains_on_station
    return if self.trains.empty? || self.stations.empty?

    self.clear_screen

    self.print_stations
    station_index = gets_station_index
    validate!(station_index, self.stations)

    trains = [] 
    self.stations[station_index].trains.each { |number, train| trains << train }
    print_trains(trains)

    push_enter_for_continue
  end
 
  def print_stations_only
    self.clear_screen
    print_stations
    push_enter_for_continue
  end
 
  def print_stations
    self.stations.each_with_index { |station, index| puts "[#{index}] #{station.name}" }
  end

  def print_routes_only
    self.clear_screen
    print_routes
    push_enter_for_continue
  end

  def print_routes
    self.routes.each_with_index do |route, index|
      stations = []
      route.stations.each { |station| stations << station.name }
      puts "[#{index}] #{stations.join(" -> ")}"
    end  
  end

  def validate!(index, object)
    raise "Индекс не существует (#{index})" if !index.is_a?(Integer) || object[index].nil?
  end

  def print_all_trains_only
    self.clear_screen
    print_all_trains
    push_enter_for_continue
  end

  def print_all_trains
    print_trains(self.trains)
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
    push_enter_for_continue
  end

  private

  def error_text(error)
    puts "Ошибка #{error}"
  end

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
    return (input.empty? || /\D/.match(input)) ? input : input.to_i
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

  def push_enter_for_continue
    puts
    puts "Для продолжения нажмите Enter..."
    gets
  end

end
