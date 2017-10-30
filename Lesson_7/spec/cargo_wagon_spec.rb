require 'cargo_wagon'

describe CargoWagon do
  before(:each) do
    @cargo_wagon = CargoWagon.new
  end
 
  context "Модульный интерфейс" do
    context "Модуль Manufactura" do
      let(:company_name) { "TrainManufactura" }
      it "Устанавливает возвращает название производителя" do
        @cargo_wagon.company_name=(:company_name)
        expect(@cargo_wagon.company_name).to eql(:company_name)
      end
    end
  end
end
