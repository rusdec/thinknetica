class Route

  attr_reader :stations

  def initialize(first_station, last_station)
    @stations = [first_station, last_station]
    validate!
  end

  def validate!
    raise StandardError, "Начальная и конечная станции должны различаться" if self.stations[0] == self.stations[1]
    self.stations.each do |station|
      raise StandardError, "Станция должна быть объектом типа Station" unless station.is_a?(Station)
    end
  end

  def valid?
    self.validate!
  end

  def add_station(station)
    raise StandardError, "Маршрут уже содержит станцию '#{station.name}'" if stations.include?(station)
    raise StandardError, "Станция должна быть объектом типа Station" unless station.is_a?(Station)

    @stations.insert(-2, station)
  end
  
  def delete_station
    raise StandardError, "Промежуточные станции в маршруте отсутствуют" unless self.stations.length > 2
    raise StandardError, "На станции '#{self.stations[-2].name}' размещены поезда" if self.stations[-2].trains_count > 0     

    @stations.delete_at(-2)
  end

end
