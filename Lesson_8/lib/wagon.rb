require_relative 'manufactura'

class Wagon

  include Manufactura

  TYPES = [
    {
      type: 'CargoWagon',
      name: 'Грузовой'
    },
    {
      type: 'PassengerWagon',
      name: 'Пассажирский'
    }
  ]

  attr_reader :number

  def initialize
  end

  def generate_number
    srand.to_s.slice(0..7)
  end
end
