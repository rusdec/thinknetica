require_relative 'validation'

class Station

  include Validation

  NAME_FORMAT = /^[a-zа-я]{1,30}([ \-][a-zа-я]{1,30})?([ \-][a-zа-я]{1,30})?([ \-][\d]{1,4})?$/i

  attr_reader :name, :trains

  @@stations = []

  validate :name, :type, String
  validate :name, :format, NAME_FORMAT

  def self.all
    @@stations
  end

  def initialize(name)
    @name = name
    @trains = {}

    validate!

    @@stations << self
  end

  def each_train
    trains.each { |train| yield(train) } if block_given?
  end

  def trains_count
    trains.length
  end

  def trains_count_by_type(type)
    type = type.to_sym
    trains = @trains.select { |train| train.class.to_s == type }
    trains.length
  end

  def send_train(number)
    raise StandardError, "Поезд с номером №#{number} отсутствует" if trains[number].nil?
    trains.delete(number)
  end

  def place_train(train)
    raise StandardError, 'Можно разместить только поезд' unless train.is_a?(Train)
    @trains[train.number] = train
  end
end
