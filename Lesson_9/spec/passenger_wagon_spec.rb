=begin
- Добавить атрибут общего кол-ва мест (задается при создании вагона)
- Добавить метод, который "занимает места" в вагоне (по одному за раз)
- Добавить метод, который возвращает кол-во занятых мест в вагоне
- Добавить метод, возвращающий кол-во свободных мест в вагоне.
=end

require 'passenger_wagon'

describe PassengerWagon do
  let(:number_of_seats) { 10 }

  before(:each) do
    @passenger_wagon = PassengerWagon.new(number_of_seats)
  end
  
  context "В созданном вагоне" do
    it "Можно узнать кол-во свободных мест" do
      expect(@passenger_wagon).to respond_to(:number_of_free_seats)
    end
    it "Можно узнать кол-во занятых мест" do
      expect(@passenger_wagon).to respond_to(:number_of_busy_seats)
    end
    context "Можно занять место, при этом" do
      before(:each) do
        @number_of_free_seats_before = @passenger_wagon.number_of_free_seats
        @number_of_busy_seats_before = @passenger_wagon.number_of_busy_seats
        @passenger_wagon.busy_seat
      end
      it "Количество свободных мест должно уменьшиться на одно" do
        expect(@passenger_wagon.number_of_free_seats).to eq(@number_of_free_seats_before-1)
      end
      it "Количество занятых мест должно увеличиться на одно" do
        expect(@passenger_wagon.number_of_busy_seats).to eq(@number_of_busy_seats_before+1)
      end
    end
    context "Можно освободить место" do
      before(:each) do
        @passenger_wagon.busy_seat
        @number_of_free_seats_before = @passenger_wagon.number_of_free_seats
        @number_of_busy_seats_before = @passenger_wagon.number_of_busy_seats
        @passenger_wagon.free_seat
      end
      it "Количество свободных мест должно увеличиться на одно" do
        expect(@passenger_wagon.number_of_free_seats).to eq(@number_of_free_seats_before+1)
      end
      it "Количество занятых мест должно уменьшиться на одно" do
        expect(@passenger_wagon.number_of_busy_seats).to eq(@number_of_busy_seats_before-1)
      end
    end
  end

  context "Модульный интерфейс" do
    context "Модуль Manufactura" do
      let(:company_name) { "TrainManufactura" }
      it "Устанавливает/возвращает название производителя" do
        @passenger_wagon.company_name=(:company_name)
        expect(@passenger_wagon.company_name).to eql(:company_name)
      end
    end
  end
end
