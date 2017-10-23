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

  RGXP_TRAIN_NUMBER_FORMAT = /^[a-zа-я\d]{3}-?[a-zа-я\d]{2}$/i

  attr_reader :speed, :number, :current_station_index, :route

  def initialize(number)
    @number = number
    @speed = 0
    @wagons = []
    @route = nil
    @current_station_index = nil
    @@trains[number] = self
    validate!
  end
 
  def validate!
    raise StandardError, "Неправильный формат номера (#{self.number})" if self.number !~ RGXP_TRAIN_NUMBER_FORMAT
    true
  end

  def valid?
    self.validate!
  rescue
    false
  else
    true
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
    raise StandardError, "Нельзя прицепить: поезд движется" if self.speed > 0
    
    @wagons << wagon  
  end
  
  def delete_wagon
    raise StandardError, "У поезда нет прицепленных вагонов" if wagons_count == 0
    raise StandardError, "Нельзя отцепить: поезд движется" if self.speed > 0

    @wagons.pop
  end

  def wagons_count
    @wagons.length
  end

  def route=(route)
    raise StandardError, "В качестве маршрута можно назначить только маршрут" unless route.is_a?(Route)
      
    @route = route
    @current_station_index = 0
    self.current_station.place_train(self)
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
    raise StandardError, "Это конечная станция" unless next_station

    move(self.current_station_index + 1)
  end
  
  def move_backward
    raise StandardError, "Это начальная станция" unless previous_station

    move(self.current_station_index - 1)
  end
  
  protected 

  def move(n)
    current_station.send_train(self.number) 
    @current_station_index = n
    current_station.place_train(self)
  end

  def station(n)
    (n >= 0 && n < self.route.stations.length) ? self.route.stations[n] : nil
  end
end
