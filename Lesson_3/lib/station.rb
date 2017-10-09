class Station
  attr_reader :name

  def initialize name
    @name = name
    @trains = {}
  end

  def trains_count
    @trains.length
  end

  def trains_count_by_type type
    type = type.to_sym
    trains = @trains.select { |number, train| train.type == type }
    trains.length
  end

  def send_train number
    if @trains[number.to_sym].is_a?(Train)
      @trains[number.to_sym].move_forward
      @trains.delete(number.to_sym)
    end
  end

  def place_train train
    @trains[train.number.to_sym] = train if train.is_a?(Train)
  end

end
