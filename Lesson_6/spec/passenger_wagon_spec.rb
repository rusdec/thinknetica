require 'passenger_wagon'

describe PassengerWagon do
  before(:each) do
    @passenger_wagon = PassengerWagon.new
  end
 
  context "Модульный интерфейс" do
    context "Модуль Manufactura" do
      let(:company_name) { "TrainManufactura" }
      it "Устанавливает возвращает название производителя" do
        @passenger_wagon.company_name=(:company_name)
        expect(@passenger_wagon.company_name).to eql(:company_name)
      end
    end
  end
end
