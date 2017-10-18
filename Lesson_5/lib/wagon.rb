require_relative 'manufactura'

class Wagon

  include Manufactura

  attr_reader :number

  def initialize
    @number = generate_number
  end

  def generate_number
    srand.to_s.slice(0..7)
  end
end
