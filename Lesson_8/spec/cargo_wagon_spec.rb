=begin
- Добавить атрибут общего объема (задается при создании вагона)
- Добавить метод, которые "занимает объем" в вагоне (объем указывается в качестве параметра метода)
- Добавить метод, который возвращает занятый объем
- Добавить метод, который возвращает оставшийся (доступный) объем
=end
require 'cargo_wagon'

describe CargoWagon do
  let(:total_volume) { 100 }

  before(:each) do
    @cargo_wagon = CargoWagon.new(total_volume)
  end
  
  context "В созданном вагоне" do
    it "Можно узнать кол-во свободного объёма" do
      expect(@cargo_wagon).to respond_to(:free_volume)
    end
    it "Можно узнать кол-во занятого объёма" do
      expect(@cargo_wagon).to respond_to(:occupied_volume)
    end
    context "Можно занять объём, при этом" do
      let(:volume_value) { 25 }
      before(:each) do
        @free_volume_before = @cargo_wagon.free_volume
        @occupied_volume_before = @cargo_wagon.occupied_volume
        @cargo_wagon.load(volume_value)
      end
      it "Количество свободного объёма должно уменьшиться на переданное значение" do
        expect(@cargo_wagon.free_volume).to eq(@free_volume_before - volume_value)
      end
      it "Количество занятого объёма должно увеличиться на переданное значение" do
        expect(@cargo_wagon.occupied_volume).to eq(@occupied_volume_before + volume_value)
      end
    end
    context "Можно освободить объём, при этом" do
      let(:volume_value) { 25 }
      before(:each) do
        @cargo_wagon.load(volume_value)
        @free_volume_before = @cargo_wagon.free_volume
        @occupied_volume_before = @cargo_wagon.occupied_volume
        @cargo_wagon.unload(volume_value)
      end
      it "Количество свободного объёма должно увеличиться на переданное значение" do
        expect(@cargo_wagon.free_volume).to eq(@free_volume_before + volume_value)
      end
      it "Количество занятого объёма должно уменьшиться на переданное значение" do
        expect(@cargo_wagon.occupied_volume).to eq(@occupied_volume_before - volume_value)
      end
    end
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
