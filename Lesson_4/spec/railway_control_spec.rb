=begin
Создать программу в файле main.rb, которая будет позволять пользователю через текстовый интерфейс делать следующее:
  - Создавать станции
  - Создавать поезда
  - Создавать маршруты и управлять станциями в нем (добавлять, удалять)
  - Назначать маршрут поезду
  - Добавлять вагоны к поезду
  - Отцеплять вагоны от поезда
  - Перемещать поезд по маршруту вперед и назад
  - Просматривать список станций и список поездов на станции
=end

require 'railway_control'
require 'station'
require 'train'
require 'route'

describe RailwayControl do

  before(:each) do
    @railway_controller = RailwayControl.new
  end

  context "Интерфейс" do
    it "Создавать станции" do
      expect(@railway_controller).to respond_to(:create_station)
    end
    it "Создавать поезда" do
      expect(@railway_controller).to respond_to(:create_train)
    end
    it "Создавать маршруты" do
      expect(@railway_controller).to respond_to(:create_route)
    end
    it "Добавлять станцию в маршрут" do
      expect(@railway_controller).to respond_to(:add_station_to_route)
    end
    it "Удалять станцию из маршрута" do
      expect(@railway_controller).to respond_to(:delete_station_from_route)
    end
    it "Назначать маршрут поезду" do
      expect(@railway_controller).to respond_to(:set_route)
    end
    it "Добавлять вагоны к поезду" do
      expect(@railway_controller).to respond_to(:add_wagon_to_train)
    end
    it "Отцеплять вагоны от поезда" do
      expect(@railway_controller).to respond_to(:delete_wagon_from_train)
    end
    it "Перемещать поезд по маршруту вперед и назад" do
      expect(@railway_controller).to respond_to(:move_to)
    end
    it "Просматривать cписок поездов на станции" do
      expect(@railway_controller).to respond_to(:get_trains)
    end
    it "Просматривать список станций" do
      expect(@railway_controller).to respond_to(:get_stations)
    end
  end

  context "Создание" do
    it "Должен содержать пустой хеш trains" do
      expect(@railway_controller.trains).to eql({})
    end
    it "Должен содержать пустой массив routes" do
      expect(@railway_controller.routes).to eql([])
    end
    it "Должен содержать пустой массив stations" do
      expect(@railway_controller.stations).to eql([])
    end
  end

  context "Использование" do
    context "При создании станции" do
      before(:each) do
        @railway_controller = RailwayControl.new
        @station_name = "Cанкт-Петербург"
        @stations_count_before = @railway_controller.stations.length
        @railway_controller.create_station @station_name
      end
      it "Станция добавляется в массив stations" do
        expect(@railway_controller.stations.length).to eql(@stations_count_before + 1)
      end
      it "К созданной станции можно обратиться по номеру в массиве stations" do
        expect(@railway_controller.stations[0]).to be_a(Station)
      end
    end
    context "При создании поезда" do
      before(:each) do
        @railway_controller = RailwayControl.new
        @train_number = "12345"
        @trains_count_before = @railway_controller.trains.length
        @railway_controller.create_train @train_number
      end
      it "Поезд добавляется в хеш trains" do
        expect(@railway_controller.trains.length).to eql(@trains_count_before + 1)
      end
      it "К созданному поезду можно обратиться по номеру поезда" do
        expect(@railway_controller.trains[@train_number]).to be_a(Train)
      end
    end
    context "При создании маршрута" do
      before(:each) do
        @railway_controller = RailwayControl.new
        @railway_controller.create_station "Санкт-Петербург"
        @railway_controller.create_station "Москва"
        @routes_count_before =  @railway_controller.routes.length
        @railway_controller.create_route(@railway_controller.stations[0], @railway_controller.stations[1])
      end
      it "Маршут добавляется в массив routes" do
        expect(@railway_controller.routes.length).to eql(@routes_count_before + 1)
      end
      it "К созданному маршруту можно обратиться по номеру в массиве routes" do
        expect(@railway_controller.routes[0]).to be_a(Route)
      end
    end

    context "При добавлении вагона" do
      before(:each) do
        @railway_controller = RailwayControl.new
        @train_number = "12345"
        @railway_controller.create_train @train_number
        @wagons_count_before = @railway_controller.trains[@train_number].wagons_count
      end
      it "Вагон добавляется к указанному поезду" do
        @railway_controller.add_wagon_to_train(@railway_controller.trains[@train_number])
        expect(@railway_controller.trains[@train_number].wagons_count).to eql(@wagons_count_before + 1)
      end
    end
    context "При удвлении вагона" do
      before(:each) do
        @railway_controller = RailwayControl.new
        @train_number = "12345"
        @railway_controller.create_train @train_number
        @railway_controller.add_wagon_to_train(@railway_controller.trains[@train_number])
        @wagons_count_before = @railway_controller.trains[@train_number].wagons_count
      end
      it "Вагон добавляется к указанному поезду" do
        @railway_controller.delete_wagon_from_train(@railway_controller.trains[@train_number])
        expect(@railway_controller.trains[@train_number].wagons_count).to eql(@wagons_count_before - 1)
      end
    end
    
  end
end
