class Station
  
  attr_reader :name, :trains

  @@station_count = 0

  def self.all
    @@station_count
  end

  def initialize(name)
    @name = name
    @trains = {}
    
    @@station_count += 1
  end

  def trains_count
    @trains.length
  end

  def trains_count_by_type(type)
    type = type.to_sym
    trains = @trains.select { |number, train| train.type == type }
    trains.length
  end

  def send_train(number)
    @trains.delete(number) if @trains[number].is_a?(Train)
  end

  def place_train(train)
    @trains[train.number] = train if train.is_a?(Train)
  end

end

puts Station.all
