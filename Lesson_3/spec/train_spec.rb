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

describe Train do
  before(:each) do
    @train = Train.new("12345", "passenger", 5)
  end
  context "Доступные методы" do
    it "Должен возвращать текущую скорость (speed)" do
      expect(@train).to respond_to(:speed)
    end
    it "Должен возвращать тип (type)" do
      expect(@train).to respond_to(:type)
    end
    it "Должен возвращать номер (number)" do
      expect(@train).to respond_to(:number)
    end
    it "Должен возвращать кол-во вагонов (wagons_count)" do
      expect(@train).to respond_to(:wagons_count)
    end
    it "Должен увеличивать скорость" do
      expect(@train).to respond_to(:speed_up)
    end
    it "Должен уменьшать скорость" do
      expect(@train).to respond_to(:speed_down)
    end
    it "Должен приплять вагоны" do
      expect(@train).to respond_to(:wagon_delete)
    end
    it "Должен отцеплять вагоны" do
      expect(@train).to respond_to(:wagon_add)
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

end
