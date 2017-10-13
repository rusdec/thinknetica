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
require 'route'

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

  context "Интерфейс" do
    it "Может возвращать список всех поездов на станции" do
      expect(@station).to respond_to(:trains_count)
    end
    it "Может возвращать список поездов на станции по типу" do
      expect(@station).to respond_to(:trains_count_by_type)
    end
    it "Может отправлять поезда" do
      expect(@station).to respond_to(:send_train)
    end
    it "Может принимать поезда" do
      expect(@station).to respond_to(:place_train)
    end
    it "Может отдавать имя" do
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
      @train = Train.new("12345")
      @station_last = Station.new("Санкт-Петербург")
      @route = Route.new(@station, @station_last)
      @train.route=@route
    end
    context "Список всех поездов на станции" do
      it "Должен возвращать кол-во поездов на станции" do
        expect(@station.trains_count).to eql(1) #поезд устанавливается на 1-ую станцию
      end
    end
    context "Отправка/прибытие поезда" do
      before(:each) do
        @station_first = Station.new("Москва")
        @station_last = Station.new("Санкт-Петербург")
        @route = Route.new(@station_first, @station_last)
        @train.route=@route
      end
      context "Прибытие поезда" do
        it "Может принять поезд" do
          trains_count_before = @station.trains_count
          train2 = Train.new("РВ-387854-330А")
          @station.place_train train2
          expect(@station.trains_count).to eql(trains_count_before+1)
        end
      end
      context "Отправка поезда по его номеру" do
        it "Должен удалить поезд поезд с этим номером" do
          number = "12345"

          @station.place_train @train
          trains_count_before = @station.trains_count
          @station.send_train number
          expect(@station.trains_count).to eql(trains_count_before-1)
        end
        it "Поезд должен прибыть на следующую станцию" do
          number = "12345"
          @station.place_train @train
          @train.move_forward
          expect(@train.current_station.name).to eql(@station_last.name)
        end
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
