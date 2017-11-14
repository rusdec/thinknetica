require_relative 'validation'

class Route

  include Validation

  attr_reader :stations

  validate :stations, :first_last_uniq
  validate :stations, :each_type, Station

  def initialize(first_station, last_station)
    @stations = [first_station, last_station]
    validate!
  end

  def add_station(station)
    raise StandardError, "Маршрут уже имеет станцию '#{station.name}'" if stations.include?(station)
    raise StandardError, 'Станция должна быть объектом типа Station' unless station.is_a?(Station)
    @stations.insert(-2, station)
  end

  def delete_station
    raise StandardError, 'Промежуточные станции в маршруте отсутствуют' unless stations.length > 2
    station = stations[-2]
    raise StandardError, "На станции '#{station.name}' размещены поезда" if station.trains_count > 0
    @stations.delete_at(-2)
  end
end
