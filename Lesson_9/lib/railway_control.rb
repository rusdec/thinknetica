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
    @wagons = []
    @statistic = RailwayStatistic.new
  end

  def create_station
    station_name = gets_station_name
    @stations << Station.new(station_name)

    "Станция '#{station_name}' создана"
  end

  def create_train
    train_type = gets_train_type

    number = gets_train_number
    case train_type[:type]
    when 'CargoTrain' then train = CargoTrain.new(number)
    when 'PassengerTrain' then train = PassengerTrain.new(number)
    end
  rescue StandardError => error
    clear_screen
    puts error
    push_enter_for_continue
    retry
  else
    @trains << train
    "Поезд '№#{number}' тип '#{train_type[:name]}' создан"
  end

  def create_route
    raise StandardError, 'Нужны минимум 2 созданные станции' if stations.length < 2

    first_station = gets_station { puts 'Начальная станция:' }
    last_station = gets_station { puts 'Конечная станция:' }

    routes << Route.new(first_station, last_station)

    "Маршрут '#{first_station.name} -> #{last_station.name}' создан"
  end

  def add_station_to_route
    raise StandardError, 'Нет маршрутов' if routes.empty?

    station = gets_station
    route = gets_route

    route.add_station(station)
    "Станция '#{station.name}' добавлена в маршрут"
  end

  def delete_station_from_route
    raise StandardError, 'Нет маршрутов' if routes.empty?

    route = gets_route
    route.delete_station

    "Станция '#{route.stations[-2].name}' удалена из маршрута"
  end

  def add_route_to_train
    raise StandardError, 'Нет поездов' if trains.empty?
    raise StandardError, 'Нет маршрутов' if routes.empty?

    train = gets_train

    train.route = gets_route
    "Маршрут добавлен к поезду №#{train.number}"
  end

  def add_wagon_to_train
    raise StandardError, 'Нет поездов' if trains.empty?

    train = gets_train

    case train.class.to_s
    when 'CargoTrain' then train.add_wagon(create_cargo_wagon)
    when 'PassengerTrain' then train.add_wagon(create_passenger_wagon)
    end

    "Вагон добавлен к поезду №#{train.number}"
  end

  def use_wagon
    raise StandardError, 'Нет поездов' if trains.empty?

    train = gets_train
    raise StandardError, 'Нет вагонов' if train.wagons.empty?
    wagon = gets_wagon(train)

    case train.class.to_s
    when 'CargoTrain' then use_cargo_wagon(wagon)
    when 'PassengerTrain' then wagon.busy_seat
    end

    "Пространство в вагоне №#{wagon.number} поезда №#{train.number} было успешно занято"
  end

  def free_wagon
    raise StandardError, 'Нет поездов' if trains.empty?

    train = gets_train
    wagon = gets_wagon(train)

    case train.class.to_s
    when 'CargoTrain' then free_cargo_wagon(wagon)
    when 'PassengerTrain' then wagon.free_seat
    end

    "Пространство в вагоне №#{wagon.number} поезда №#{train.number} освобождено"
  end

  def delete_wagon_from_train
    raise StandardError, 'Нет поездов' if trains.empty?

    train = gets_train

    train.delete_wagon
    "Вагон отцеплен от поезда №#{train.number}"
  end

  def move_train_forward
    move_train(:move_forward)
  end

  def move_train_backward
    move_train(:move_backward)
  end

  def print_train_types
    Train::TYPES.each_with_index do |train_type, index|
      puts "[#{index}] #{train_type[:name]}"
    end
  end

  def print_trains_on_one_station
    raise StandardError, 'Нет станций' if stations.empty?

    station = gets_station

    clear_screen
    print_trains_on_station(station)

    push_enter_for_continue
  end

  def print_trains_on_each_station
    raise StandardError, 'Нет станций' if stations.empty?

    clear_screen

    stations.each do |station|
      print_trains_on_station(station)
      puts
    end

    push_enter_for_continue
  end

  def print_stations_only
    clear_screen
    print_stations
    push_enter_for_continue
  end

  def print_stations
    stations.each_with_index { |station, index| puts "[#{index}] #{station.name}" }
  end

  def print_routes_only
    clear_screen
    print_routes
    push_enter_for_continue
  end

  def print_routes
    routes.each_with_index do |route, index|
      stations = []
      route.stations.each { |station| stations << station.name }
      puts "[#{index}] #{stations.join(' -> ')}"
    end
  end

  def validate!(index, object)
    raise "Индекс не существует (#{index})" if !index.is_a?(Integer) || object[index].nil?
  end

  def print_all_trains_only
    clear_screen
    print_all_trains
    push_enter_for_continue
  end

  def print_all_trains
    print_trains(trains)
  end

  def clear_screen
    print "\e[2J\e[f"
  end

  def print_short_statistic
    statistic.calculate_short_statistic(current_state_data)
    statistic.print_short_statistic
  end

  def print_extended_statistic
    statistic.calculate_extended_statistic(current_state_data)
    statistic.print_extended_statistic
    push_enter_for_continue
  end

  private

  def error_text(error)
    puts "Ошибка #{error}"
  end

  def current_state_data
    {
      trains: trains,
      routes: routes,
      stations: stations
    }
  end

  def gets_train_type
    clear_screen
    print_train_types
    print 'Введите индекс типа поезда: '
    type_index = gets_integer
    validate!(type_index, Train::TYPES)

    Train::TYPES[type_index]
  end

  def gets_wagon(train)
    clear_screen
    print_wagons(train)
    print 'Введите индекс вагона: '
    wagon_index = gets_integer
    validate!(wagon_index, train.wagons)

    train.wagons[wagon_index]
  end

  def gets_station_name
    clear_screen
    print 'Введите название станции: '
    gets.chomp.strip
  end

  def gets_station
    clear_screen
    yield if block_given?
    print_stations
    print 'Введите индекс станции: '
    station_index = gets_integer
    validate!(station_index, stations)

    stations[station_index]
  end

  def gets_train_number
    clear_screen
    print 'Задайте номер поезда: '
    gets.chomp.strip
  end

  def gets_train
    clear_screen
    print_all_trains
    print 'Введите индекс поезда: '
    train_index = gets_integer
    validate!(train_index, trains)

    trains[train_index]
  end

  def gets_route
    clear_screen
    print_routes
    print 'Введите индекс маршрута: '
    route_index = gets_integer
    validate!(route_index, routes)

    routes[route_index]
  end

  def gets_number_of_seats
    clear_screen
    print 'Введите кол-во мест в вагоне: '
    gets_integer
  end

  def gets_volume
    clear_screen
    print 'Введите объём: '
    gets_integer
  end

  def gets_integer
    input = gets.chomp.strip
    input.empty? || /\D/.match(input) ? input : input.to_i
  end

  def print_wagons(train)
    train.wagons.each_with_index { |wagon, index| puts "[#{index}] #{wagon}" }
  end

  def print_trains_on_station(station)
    puts "Станция: #{station.name} (поездов: #{station.trains.length})"
    station.each_train do |train|
      puts train.to_s
      train.each_wagon { |wagon| puts wagon.to_s }
      puts
    end
  end

  def print_trains(trains)
    trains.each_with_index do |train, index|
      printable_data = [
        "[#{index}] Поезд №#{train.number}",
        "Тип: #{train.type[0][:name]}",
        "Вагонов: #{train.wagons_count}"
      ]
      printable_data << "Текущая станция: #{train.current_station.name}" unless train.route.nil?
      puts printable_data.join(' | ')
    end
  end

  def push_enter_for_continue
    puts 'Для продолжения нажмите Enter...'
    gets
  end

  def move_train(move_direction)
    raise StandardError, 'Нет поездов' if trains.empty?
    raise StandardError, 'Нет маршрутов' if routes.empty?

    train = gets_train
    raise StandardError, "У поезда №#{train.number} нет маршрута" if train.route.nil?

    train.public_send move_direction

    "Поезд №#{train.number} прибыл на станцию '#{train.current_station.name}'"
  end

  def free_cargo_wagon(wagon)
    volume = gets_volume
    wagon.unload(volume)
  end

  def use_cargo_wagon(wagon)
    volume = gets_volume
    wagon.load(volume)
  end

  def use_passenger_wagon(wagon)
    wagon.busy_seat
  end

  def create_cargo_wagon
    CargoWagon.new(gets_volume)
  end

  def create_passenger_wagon
    PassengerWagon.new(gets_number_of_seats)
  end
end
