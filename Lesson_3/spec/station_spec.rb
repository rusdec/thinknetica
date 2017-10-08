=begin
Класс Station (Станция):
  Имеет название, которое указывается при ее создании
  Может принимать поезда (по одному за раз)
  Может возвращать список всех поездов на станции, находящиеся в текущий момент
  Может возвращать список поездов на станции по типу (см. ниже): кол-во грузовых, пассажирских
  Может отправлять поезда (по одному за раз, при этом, поезд удаляется из списка поездов, находящихся на станции).
=end


require 'station'
require 'train'

describe Station do

  let(:station_name) { "Москва" }

  before(:each) do
    @station = Station.new(station_name)
  end

  context "Создание" do
    it "Должен принимать название (name)" do
      allow(Station).to receive(:new).with(an_instance_of(String))
    end
    it "Кол-во поездов на станции = 0" do
      expect(@station.trains_count).to eql(0)
    end
  end

  context "Доступные методы" do
    it "возвращать список всех поездов на станции" do
      expect(@station).to respond_to(:trains_count)
    end
    it "возвращать список поездов на станции по типу" do
      expect(@station).to respond_to(:trains_count_by_type)
    end
    it "отправлять поезда" do
      expect(@station).to respond_to(:send_train)
    end
    it "принимать поезда" do
      expect(@station).to respond_to(:place_train)
    end
    it "отдавать имя" do
      expect(@station).to respond_to(:name)
    end
  end


  context "Обязательные параметры" do
    it "Должна иметь имя" do
      expect(@station.name).to eql(station_name)
    end
  end
 
  context "Поезда" do
    before(:each) do
      @train = Train.new("12345", "passenger", 5)
    end
    context "Список всех поездов на станции" do
      it "Должен возвращать кол-во поездов на станции" do
        expect(@station.trains_count).to eql(0)  
      end
      it "Должен возвращать кол-во поездов на станции по типу" do
        @station.place_train @train
        expect(@station.trains_count_by_type "passenger").to eql(1)  
        expect(@station.trains_count_by_type "freight").to eql(0)  
      end
    end
    context "Отправка поезда" do
      context "Прибытие поезда" do
        it "Может принять поезд" do
          trains_count_before = @station.trains_count
          train2 = Train.new("РВ-387854-330А", "passenger", 4)
          @station.place_train train2
          expect(@station.trains_count).to eql(trains_count_before+1)
        end
      end
      it "Должен отправить поезд по его номеру" do
        number = "12345"
        @station.place_train @train
        trains_count_before = @station.trains_count
        @station.send_train number
        expect(@station.trains_count).to eql(trains_count_before-1)
      end
      it "Если поезда с переданным номером нет, отправка не происходит" do
        number = "9283593275298785223"
        @station.place_train @train
        trains_count_before = @station.trains_count
        @station.send_train number
        expect(@station.trains_count).to eql(trains_count_before)
      end
    end
  end

end
