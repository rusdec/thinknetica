require_relative 'wagon'

class PassengerWagon < Wagon
  attr_reader :number_of_seats

  def initialize(number_of_seats)
    raise StandardError, 'Кол-во мест должно быть целое число' unless number_of_seats.is_a?(Integer)
    raise StandardError, 'Кол-во мест должно быть больше 0' if number_of_seats <= 0

    @number = generate_number
    @number_of_seats = number_of_seats
    self.seats = []
  end

  def busy_seat
    raise StandardError, 'Нет свободных мест' if number_of_busy_seats >= number_of_seats
    seats << 1
  end

  def free_seat
    raise StandardError, 'Все места свободны' if number_of_free_seats == number_of_seats
    seats.pop
  end

  def to_s
    "Вагон '№#{number}' "\
    "тип '#{self.class}' "\
    "места своб./зан. '#{number_of_free_seats}/#{number_of_busy_seats}'"
  end

  def number_of_free_seats
    number_of_seats - number_of_busy_seats
  end

  def number_of_busy_seats
    seats.length
  end

  protected

  attr_accessor :seats
end
