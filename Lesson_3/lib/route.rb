class Route

  @stations

  def initialize first_station, last_station
    @stations = [first_station, last_station]
  end

  def add_station station
    if station.is_a?(Station)
      last_station = @stations.pop
      @stations << station
      @stations << last_station
    end
  end
  
  def delete_station
    @stations.delete_at(-2) if @stations.length > 2
  end

  def stations
    @stations 
  end
end
