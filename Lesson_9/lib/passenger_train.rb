require_relative 'train'

class PassengerTrain < Train
  include Validation

  validate :number, :format, /^[a-zа-я\d]{3}-?[a-zа-я\d]{2}$/i, message: 'Неверный формат номера для пассажирского поезда'

  def add_wagon(wagon)
    super(wagon) if wagon.is_a?(PassengerWagon)
  end
end
