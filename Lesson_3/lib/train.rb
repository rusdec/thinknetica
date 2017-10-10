class Train
  attr_reader :speed, :type, :number, :current_station_index, :route
  @@types = [:passenger, :freight]

  def initialize(number, type, wagons_count)
    @number = number
    @type = @@types.include?(type.to_sym) ? type.to_sym : :passenger
    @speed = 0
    @wagons = []
    wagons_count.times { add_wagon }
  end

  def speed_up(n)
    @speed += n
  end

  def speed_down(n)
    @speed = (@speed - n >= 0) ? @speed - n : stop
  end

  def stop
    @speed = 0
  end
  
  def add_wagon
    @wagons << "wagon \##{wagons_count+1}" if @speed == 0
  end
  
  def delete_wagon
    @wagons.pop if @speed == 0  
  end

  def wagons_count
    @wagons.length
  end

  def route=(route)
    if route.is_a?(Route)
      @route = route
      @current_station_index = 0
      current_station.place_train(self)
    end
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

  def move_forward
    if next_station != nil
      current_station.send_train(self.number)
      @current_station_index += 1
      current_station.place_train(self)
    end    
  end
  
  def move_backward
    if previous_station != nil
      current_station.send_train(self.number) 
      @current_station_index -= 1
      current_station.place_train(self)
    end 
  end

  def self.types
    @@types
  end

  private 

  def station(n)
    (@route.is_a?(Route) && n >= 0 && n <= @route.stations.length) ? @route.stations[n] : nil
  end
end
