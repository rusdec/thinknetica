class RailwayStatistic

  def initialize
    @data = {
      trains: {
        count_total: nil,
        have_not_route: nil,
        have_route: nil,
      },
      routes: {
        count_total: nil,
        used: nil,
        unused: nil,
      },
      stations: {
        count_total: nil,
        used_in_routes: nil,
        unused_in_routes: nil,
        empty: nil,
        have_trains: nil
      }
    }
  end

  def calculate_short_statistic(params)
    @data[:trains][:count_total] = params[:trains].length
    @data[:routes][:count_total] = params[:routes].length
    @data[:stations][:count_total] = params[:stations].length
  end

  def print_short_statistic
    printable_objects = [
      "Станций: #{data[:stations][:count_total]}",
      "Поездов: #{data[:trains][:count_total]}",
      "Маршрутов: #{data[:routes][:count_total]}",
    ]
    puts printable_objects.join(" | ")
  end

  def calculate_extended_statistic(params)
    @trains = params[:trains]
    @routes = params[:routes]
    @stations = params[:stations]

    @data[:trains][:count_total]    = trains.length
    @data[:trains][:have_not_route] = trains_have_not_route.length
    @data[:trains][:have_route]     = trains_have_route.length
    @data[:trains][:cargo_trains]   = trains_cargo.length
    @data[:trains][:passenger_trains] = trains_passenger.length

    @data[:routes][:count_total]    = routes.length
    @data[:routes][:used]           = routes_used.length
    @data[:routes][:unused]         = routes_unused.length

    @data[:stations][:count_total]  = stations.length
    @data[:stations][:empty]        = stations_empty.length
    @data[:stations][:have_trains]  = stations_have_trains.length
    @data[:stations][:used_in_routes] = stations_used_in_routes.length
    @data[:stations][:unused_in_routes] = stations_unused_in_routes.length
  end

  def print_extended_statistic
    printable_objects = [
      {
        title: 'Поезда',
        data: [
          "Всего: #{data[:trains][:count_total]}",
          "Имеют маршрут: #{data[:trains][:have_route]}",
          "Без маршрута: #{data[:trains][:have_not_route]}",
          "Грузовые: #{data[:trains][:cargo_trains]}",
          "Пассажирские: #{data[:trains][:passenger_trains]}"
        ]
      },
      {
        title: 'Станции',
        data: [
          "Всего: #{data[:stations][:count_total]}",
          "Без поездов: #{data[:stations][:empty]}",
          "С поездами: #{data[:stations][:have_trains]}",
          "Входят в маршрут: #{data[:stations][:used_in_routes]}",
          "Не входят в маршрут: #{data[:stations][:unused_in_routes]}",
        ]
      },
      {
        title: 'Маршруты',
        data: [
          "Всего: #{data[:routes][:count_total]}",
          "Назначенные: #{data[:routes][:used]}",
          "Неназначенные: #{data[:routes][:unused]}",
        ]
      }
    ]
    printable_objects.each do |object|
      puts "=== #{object[:title]}\n\n"
      puts "#{object[:data].join(" | ")}\n\n\n"
    end
  end

  private

  attr_reader :trains, :routes, :stations, :data

  #Поезда
  def trains_statistic
    @data[:trains][:count_total] = trains_count_total
    @data[:trains][:have_not_route] = trains_have_not_route
    @data[:trains][:have_route] = trains_have_route
  end

  def trains_count_total
    trains.length
  end

  def trains_have_not_route
    trains.select { |train| train.route.nil? }
  end

  def trains_have_route
    trains.select { |train| train.route.is_a?(Route) }
  end

  def trains_passenger
    trains.select { |train| train.is_a?(PassengerTrain) }
  end
  
  def trains_cargo
    trains.select { |train| train.is_a?(CargoTrain) }
  end
  #/Поезда

  #Станции
  def stations_statistic
  end

  def stations_count_total
    stations.length
  end

  def stations_empty
    stations.select { |station| station.trains.empty? }
  end
  
  def stations_have_trains
    stations.select { |station| station.trains.length > 0 }
  end

  def stations_used_in_routes
    used_stations = {}
    stations.each do |station|
      routes.each do |route|
        used_stations[station.name] = station if route.stations.include?(station)
      end
    end

    used_stations
  end

  def stations_unused_in_routes
    unused_stations = []
    stations.each do |station|
      is_unused_station = true
      routes.each { |route| is_unused_station = false if route.stations.include?(station) }
      unused_stations << station if is_unused_station
    end

    unused_stations
  end
  #/Станции


  #Маршруты
  def routes_statistic
    
  end

  def routes_used
    used_routes = []
    routes.each do |route|
      is_route_used = false
      trains.each { |train| is_route_used = true if train.route == route }
      used_routes << route if is_route_used
    end
    
    used_routes
  end
  
  def routes_unused
    unused_routes = []
    routes.each do |route|
      is_unused_route = true
      trains.each { |train| is_unused_route = false if train.route == route }
      unused_routes << route if is_unused_route
    end

    unused_routes
  end
  #/Маршруты


end
