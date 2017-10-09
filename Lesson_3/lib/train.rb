class Train
  attr_reader :speed, :type, :number, :current_station_index, :route
  @@types = [:passenger, :freight]

  def initialize number, type, wagons_count
    @number = number
    @type = type.to_sym
    @speed = 0
    @wagons = []
    wagons_count.times { wagon_add }
  end

  def speed_up n
    @speed += n
  end

  def speed_down n
    @speed = (@speed - n >= 0) ? @speed - n : stop
  end

  def stop
    @speed = 0
  end
  
  def wagon_add 
    @wagons << "wagon \##{wagons_count+1}" if @speed == 0
  end
  
  def wagon_delete
    @wagons.pop if @speed == 0  
  end

  def wagons_count
    @wagons.length
  end

  def route= route
    if route.is_a?(Route)
      @route = route
      move_to_station 0
    end
  end
  
  def move_forward
    move_to_station @current_station_index+1
  end
  
  def move_backward
    move_to_station @current_station_index-1
  end

  def current_station
    station @current_station_index
  end

  def previous_station
    station @current_station_index-1 
  end

  def next_station
    station @current_station_index+1
  end

  def self.types
    @@types
  end

  private
 
  def move_to_station n
    if @route.stations[n].is_a?(Station) && n >= 0
      @route.stations[n].place_train(self)
      @current_station_index = n
    end
  end

  def station n
    @route.stations[n] if @route.is_a?(Route) && @route.stations[n].is_a?(Station)
  end
end
