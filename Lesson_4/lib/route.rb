class Route

  attr_reader :stations

  def initialize(first_station, last_station)
    @stations = [first_station, last_station]
  end

  def add_station(station)
    double_station = self.stations.select { |station_in_route| station_in_route == station }
    puts double_station;
    @stations.insert(-2, station) if station.is_a?(Station) && double_station.nil?
  end
  
  def delete_station
    @stations.delete_at(-2) if self.stations.length > 2
  end

end
