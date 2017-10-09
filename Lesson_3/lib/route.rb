class Route

  @stations

  def initialize first_station, last_station
    @stations = [first_station, last_station]
  end

  def add_station station
    last_station = @stations.pop
    @stations.insert(-1, station)
    @stations << last_station
  end
  
  def delete_station
  end

  def stations
    @stations 
  end
end
