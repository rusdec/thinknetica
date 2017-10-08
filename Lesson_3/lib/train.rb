class Train
  attr_reader :speed, :type, :number

  def initialize number, type, wagons_count
    @number = number
    @type = type
    @wagons = []
    wagons_count.times { wagon_add }
    @speed = 0
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
    @wagons << "Вагон №#{wagons_count+1}" if @speed == 0
  end
  
  def wagon_delete
    @wagons.pop if @speed == 0  
  end

  def wagons_count
    @wagons.length
  end

end

train = Train.new('12345','passenger',5)
