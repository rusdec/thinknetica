class Station
  attr_reader :name
  @@trains = {}

  def initialize name
    @name = name
  end

  def trains_count
    @@trains.length
  end

  def trains_count_by_type type
    type = type.to_sym
    trains = @@trains.select { |number, train| train.type == type }
    trains.length
  end

  def send_train number
    @@trains.delete(number.to_sym)
  end

  def place_train train
    @@trains[train.number.to_sym] = train
  end

end
