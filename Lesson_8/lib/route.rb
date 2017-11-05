class Route
  attr_reader :stations

  def initialize(first_station, last_station)
    @stations = [first_station, last_station]
    validate!
  end

  def validate!
    raise StandardError, 'Станции должны различаться' if stations[0] == stations[-1]
    stations.each do |station|
      raise StandardError, 'Станция должна быть объектом типа Station' unless station.is_a?(Station)
    end
  end

  def valid?
    validate!
    true
  rescue StandardError
    false
  end

  def add_station(station)
    raise StandardError, "Маршрут уже имеет станцию '#{station.name}'" if stations.include?(station)
    raise StandardError, 'Станция должна быть объектом типа Station' unless station.is_a?(Station)
    @stations.insert(-2, station)
  end

  def delete_station
    station = stations[-2]
    raise StandardError, 'Промежуточные станции в маршруте отсутствуют' unless stations.length > 2
    raise StandardError, "На станции '#{station.name}' размещены поезда" if station.trains_count > 0
    @stations.delete_at(-2)
  end
end
