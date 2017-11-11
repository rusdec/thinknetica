require 'wagon'

describe Wagon do
  before(:each) do
    @wagon = Wagon.new
  end
 
  context "Модульный интерфейс" do
    context "Модуль Manufactura" do
      let(:company_name) { "TrainManufactura" }
      it "Устанавливает возвращает название производителя" do
        @wagon.company_name=(:company_name)
        expect(@wagon.company_name).to eql(:company_name)
      end
    end
  end
end
