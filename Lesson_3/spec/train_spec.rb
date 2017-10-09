=begin
Класс Train (Поезд):
  Имеет номер (произвольная строка) и тип (грузовой, пассажирский) и количество вагонов, эти данные указываются при создании экземпляра класса
  Может набирать скорость
  Может возвращать текущую скорость
  Может тормозить (сбрасывать скорость до нуля)
  Может возвращать количество вагонов
  Может прицеплять/отцеплять вагоны (по одному вагону за операцию, метод просто увеличивает или уменьшает количество вагонов). Прицепка/отцепка вагонов может осуществляться только если поезд не движется.
  Может принимать маршрут следования (объект класса Route). 
  При назначении маршрута поезду, поезд автоматически помещается на первую станцию в маршруте.
  Может перемещаться между станциями, указанными в маршруте. Перемещение возможно вперед и назад, но только на 1 станцию за раз.
  Возвращать предыдущую станцию, текущую, следующую, на основе маршрута
=end

require 'train'
require 'route'
require 'station'

describe Train do

  context "Создание" do
    it "Доджен принимать два объекта типа номер (String), тип (String), кол-во вагонов (Integer)" do
      allow(Train).to receive(:new).with(an_instance_of(String), an_instance_of(Station), an_instance_of(Integer))
    end
  end 

  before(:each) do
    @train = Train.new("12345", "passenger", 5)
  end

  context "Доступные методы" do
    it "Может возвращать текущую скорость (speed)" do
      expect(@train).to respond_to(:speed)
    end
    it "Может возвращать тип (type)" do
      expect(@train).to respond_to(:type)
    end
    it "Может возвращать номер (number)" do
      expect(@train).to respond_to(:number)
    end
    it "Может возвращать кол-во вагонов (wagons_count)" do
      expect(@train).to respond_to(:wagons_count)
    end
    it "Может увеличивать скорость" do
      expect(@train).to respond_to(:speed_up)
    end
    it "Может уменьшать скорость" do
      expect(@train).to respond_to(:speed_down)
    end
    it "Может прицеплять вагоны" do
      expect(@train).to respond_to(:wagon_delete)
    end
    it "Может отцеплять вагоны" do
      expect(@train).to respond_to(:wagon_add)
    end
    it "Может принимать маршрут следования" do
      expect(@train).to respond_to(:route=)
    end
    it "Может перемещаться между станциями, указанными в маршруте вперёд" do
      expect(@train).to respond_to(:move_forward)
    end
    it "Может перемещаться между станциями, указанными в маршруте назад" do
      expect(@train).to respond_to(:move_backward)
    end
    it "Может возвращать предыдущую станцию" do
      expect(@train).to respond_to(:previous_station)
    end
    it "Может возвращать текущую станцию" do
      expect(@train).to respond_to(:current_station)
    end
    it "Может возвращать следующую станцию" do
      expect(@train).to respond_to(:next_station)
    end  
  end

  context "Обязательные параметры" do
    it "Должен иметь номер" do
      expect(@train.number).to eql("12345")
    end
    it "Должен иметь тип: pessenger или freigth" do
      expect(@train.type).to match(/^passenger$|^freight$/)
    end
    it "Должен иметь 0 или более вагонов" do
      expect(@train.wagons_count).to be >= 0
    end
    it "Скорость должна быть равна 0" do
      expect(@train.speed).to be == 0
    end
  end 

  context "Движение" do
    it "Должен увеличивать скорость" do
      @train.speed_up 10
      expect(@train.speed).to eql(10)
    end
    it "Должен снижать скорость" do
      @train.speed_up 10
      @train.speed_down 5
      expect(@train.speed).to eql(5)
    end
    it "Скорость не может снизиться ниже нуля" do
      @train.speed_down 1000
      expect(@train.speed).to eql(0)
    end
  end

  context "Вагоны" do
    it "Должен прицеплять вагон" do
      wagons_count_before = @train.wagons_count
      @train.wagon_add
      expect(@train.wagons_count).to eql(wagons_count_before+1)
    end
    it "Может прицеплять вагон только если скорость = 0" do
      wagons_count_before = @train.wagons_count
      @train.speed_up 5
      @train.wagon_add
      expect(@train.wagons_count).to eql(wagons_count_before)
    end

    it "Должен отцеплять вагон" do
      wagons_count_before = @train.wagons_count
      @train.wagon_add
      @train.wagon_delete
      expect(@train.wagons_count).to eql(wagons_count_before)
    end
    it "Может отцеплять вагон только если скорость = 0" do
      @train.wagon_add
      wagons_count_before = @train.wagons_count
      @train.speed_up 5
      @train.wagon_delete
      expect(@train.wagons_count).to eql(wagons_count_before)
    end
  end

  context "Маршрут следования" do
    before(:each) do
      @station_first = Station.new("Москва")
      @station_last = Station.new("Санкт-петербург")
      @station_middle = Station.new("Новгород")
      @route = Route.new(@station_first, @station_last)
      @route.add_station @station_middle
    end
    it "Может принимать маршрут следования" do
      allow(@train).to receive(:add_station).with(an_instance_of(Route))
    end
    it "Маршурт следования должен иметь тип Route" do
      route = "Новгород"
      @train.route=route
      expect(@train.current_station).to eql(nil)
    end
    it "При установке маршрута поезд отправляется на первую станцию" do
      @train.route=@route
      expect(@train.current_station).to eql(@station_first)
    end
    it "Должен возвратить текущую станцию" do
      @train.route=@route
      expect(@train.current_station).to eql(@station_first)
    end
    it "Должен ехать на след. на станцию" do
      @train.route=@route
      @train.move_forward
      expect(@train.current_station).to eql(@station_middle)
    end
    it "Должен ехать на пред. на станцию" do
      @train.route=@route
      @train.move_forward
      @train.move_backward
      expect(@train.current_station).to eql(@station_first)
    end
    it "Не может выходить за первую станцию" do
      @train.route=@route
      @train.move_backward
      expect(@train.current_station).to eql(@station_first)
    end
    it "Не может выходить за последнюю станцию" do
      @train.route=@route
      (@route.stations.length+1).times { @train.move_forward }
      expect(@train.current_station).to eql(@station_last)
    end 
  end

end
