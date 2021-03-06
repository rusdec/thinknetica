require_relative 'manufactura'

class Train

  include Manufactura

  TYPES = [
    {
      type: 'CargoTrain',
      name: 'Грузовой'
    },
    {
      type: 'PassengerTrain',
      name: 'Пассажирский'
    }
  ]

  @@trains = {}

  attr_reader :speed, :number, :current_station_index, :route

  def initialize(number)
    @number = number
    @speed = 0
    @wagons = []
    @route = nil
    @current_station_index = nil
    @@trains[number] = self
  end
  
  def self.find(train_number)
    @@trains[train_number]
  end

  def speed_up(n)
    @speed += n
  end

  def speed_down(n)
    @speed = (self.speed - n >= 0) ? self.speed - n : stop
  end

  def stop
    @speed = 0
  end
  
  def add_wagon wagon
    @wagons << wagon if self.speed == 0
  end
  
  def delete_wagon
    @wagons.pop if self.speed == 0  
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
    station(self.current_station_index)
  end

  def previous_station
    station(self.current_station_index-1)
  end

  def next_station
    station(self.current_station_index+1)
  end

  def move_forward
    move(self.current_station_index + 1) if next_station 
  end
  
  def move_backward
    move(self.current_station_index - 1) if previous_station
  end
  
  # protected здесь для того, чтобы:
  # - скрыть методы от доступа извне
  # - показать, что методы будут использоваться в классах-потомках.
  protected 

  def move(n)
    current_station.send_train(self.number) 
    @current_station_index = n
    current_station.place_train(self)
  end

  def station(n)
    (self.route.is_a?(Route) && n >= 0 && n <= self.route.stations.length) ? self.route.stations[n] : nil
  end
end
