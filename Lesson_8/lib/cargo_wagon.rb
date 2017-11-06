require_relative 'wagon'

class CargoWagon < Wagon
  attr_reader :total_volume

  def initialize(total_volume)
    raise StandardError, 'Объём должен быть целым числом' unless total_volume.is_a?(Integer)
    raise StandardError, 'Объём должен быть больше 0' if total_volume <= 0

    @number = generate_number
    @total_volume = total_volume
    @volume = 0
  end

  def load(volume)
    raise StandardError, 'Нехватает свободного объёма' if self.volume + volume > total_volume
    self.volume += volume
  end

  def unload(volume)
    raise StandardError, 'Объём не может быть отрицательным' if self.volume - volume < 0
    self.volume -= volume
  end

  def free_volume
    total_volume - self.volume
  end

  def occupied_volume
    self.volume
  end

  def to_s
    "Вагон '№#{number}' тип '#{self.class}' объём своб./зан. '#{free_volume}/#{occupied_volume}'"
  end

  protected

  attr_accessor :volume
end
