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
  ].freeze

  attr_reader :number

  def generate_number
    srand.to_s.slice(0..7)
  end
end
