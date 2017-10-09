=begin
Класс Route (Маршрут):
  Имеет начальную и конечную станцию, а также список промежуточных станций. Начальная и конечная станции указываютсся при создании маршрута, а промежуточные могут добавляться между ними.
  Может добавлять промежуточную станцию в список
  Может удалять промежуточную станцию из списка
  Может выводить список всех станций по-порядку от начальной до конечной
=end

require 'route'
require 'station'

describe Route do

  context "Создание" do
    it "Должен принимать два объекта типа Station" do
      allow(Route).to receive(:new).with(an_instance_of(Station), an_instance_of(Station))
    end
  end 

  context "Интерфейс" do
    before(:each) do
      @station_first = Station.new("Москва")
      @station_last = Station.new("Санкт-Петербург")
      @route = Route.new(@station_first, @station_last)
    end

    context "Доступные методы" do
      it "Может добавлять промежуточную станцию" do
        expect(@route).to respond_to(:add_station)
      end
      it "Может удалять промежуточную станцию" do
        expect(@route).to respond_to(:delete_station)
      end
      it "Может выводить список всех станций по-порядку от начальной до конечной" do
        expect(@route).to respond_to(:stations)
      end
    end

    context "Получение списка станций" do
      it "Должна выводить список всех станций по-порядку от начальной до конечной" do
        station_list = [@station_first, @station_last]
        expect(@route.stations).to eql(station_list)
      end
    end

    context "Добавление промежуточной станции" do
      before(:each) do
        @station_first = Station.new("Москва")
        @station_last = Station.new("Санкт-Петербург")
        @route = Route.new(@station_first, @station_last)
        @station = Station.new("Новгород")
      end
      it "Станция может добавляется только между начальной и конечной" do
        @route.add_station @station
        station_list = @route.stations
        expect(station_list[1]).to eql(@station)
      end
      it "Может добавляться только объект класса Station" do
        @route = Route.new(@station_first, @station_last)
        station_list_before = @route.stations.length
        @route.add_station "Станция_строка"
        expect(@route.stations.length).to eq(station_list_before)
      end
    end
    
    context "Удаление промежуточной станции" do
      before(:each) do
        @station = Station.new("Новгород")
      end
      it "Станция может быть удалена" do
        station_list_before = @route.stations.length
        @route.add_station @station
        @route.delete_station
        expect(@route.stations.length).to eql(station_list_before)
      end 

      it "Нельзя удалить первую и последнюю станции" do
        @route.stations.length.times { @route.delete_station }
        expect(@route.stations).to eql([@station_first, @station_last])
      end
    end

  end
end
