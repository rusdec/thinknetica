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
      expect(@railway_controller).to respond_to(:add_route_to_train)
    end
    it "Добавлять вагоны к поезду" do
      expect(@railway_controller).to respond_to(:add_wagon_to_train)
    end
    it "Отцеплять вагоны от поезда" do
      expect(@railway_controller).to respond_to(:delete_wagon_from_train)
    end
    it "Перемещать поезд по маршруту вперёд" do
      expect(@railway_controller).to respond_to(:move_train_forward)
    end
    it "Перемещать поезд по маршруту назад" do
      expect(@railway_controller).to respond_to(:move_train_backward)
    end
    it "Просматривать cписок поездов на станции" do
      expect(@railway_controller).to respond_to(:get_trains_on_station)
    end
    it "Просматривать список станций" do
      expect(@railway_controller).to respond_to(:get_stations)
    end
  end #/Интерфейс

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
  end #/Создание

  context "Использование" do

    context "При действии со станциями" do
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
      end #/При создании станции

      context "При уже созданной станции" do
        before(:each) do
          @railway_controller = RailwayControl.new
          @railway_controller.create_station "Санкт-Петербург"
          @railway_controller.create_station "Москва"
          @first_station_index = 0
          @last_station_index = 1
          @railway_controller.create_route({
            first_station_index: @first_station_index,
            last_station_index: @last_station_index
          })
          @train_number = "123456"
          @railway_controller.create_train(@train_number)
          @railway_controller.add_route_to_train({
            route_index: @first_station_index,
            train_number: @train_number
          })
          @trains = @railway_controller.get_trains_on_station(@first_station_index)
        end #/before

        it "К созданной станции можно обратиться по номеру в массиве stations" do
          expect(@railway_controller.stations[0]).to be_a(Station)
        end

        context "Можно посмотреть cписок поездов на станции" do
          it "Количество поездов должно быть равно 1" do
            expect(@trains.length).to eql(1)
          end
          it "Добавленный поезд и поезд при выводе должен быть одним и тем же поездом" do
            expect(@trains[@train_number]).to eql(@railway_controller.trains[@train_number])
          end
        end
      end #/При уже созданной станции

    end #/При действии со станциями

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
    end #/При создании поезда

    context "При создании маршрута" do
      before(:each) do
        @railway_controller = RailwayControl.new
        @railway_controller.create_station "Санкт-Петербург"
        @railway_controller.create_station "Москва"
        @routes_count_before =  @railway_controller.routes.length
        @railway_controller.create_route({
          first_station_index: 0,
          last_station_index: 1
        })
      end
      it "Маршут добавляется в массив routes" do
        expect(@railway_controller.routes.length).to eql(@routes_count_before + 1)
      end
      it "К созданному маршруту можно обратиться по номеру в массиве routes" do
        expect(@railway_controller.routes[0]).to be_a(Route)
      end
    end #/При создании маршрута

    context "При действии с вагонами" do
      before(:each) do
        @railway_controller = RailwayControl.new
        @train_number = "12345"
        @railway_controller.create_train @train_number
      end
      context "При добавлении вагона" do
        it "Вагон добавляется к указанному поезду" do
          @wagons_count_before = @railway_controller.trains[@train_number].wagons_count
          @railway_controller.add_wagon_to_train(@train_number)
          expect(@railway_controller.trains[@train_number].wagons_count).to eql(@wagons_count_before + 1)
        end
      end
      context "При удалении вагона" do
        it "Вагон удаляется из указанного поезда" do
          @railway_controller.add_wagon_to_train(@train_number)
          @wagons_count_before = @railway_controller.trains[@train_number].wagons_count
          @railway_controller.delete_wagon_from_train(@train_number)
          expect(@railway_controller.trains[@train_number].wagons_count).to eql(@wagons_count_before - 1)
        end
      end
    end #/При действии с вагонами

    context "При действии с маршрутами" do
      before(:each) do
        @train_number = "12345"
        @railway_controller.create_train(@train_number)
        @railway_controller = RailwayControl.new
        @railway_controller.create_station("Санкт-петербург")
        @railway_controller.create_station("Москва")
        @first_station = @railway_controller.stations.first
        @last_station = @railway_controller.stations.last
        @railway_controller.create_route({
          first_station_index: 0,
          last_station_index: 1
        })
      end #/before
      
      context "При добавлении станции в маршурт" do
        it "Станция добавляется в массив маршрута и доступна по порядковому индексу" do
          @railway_controller.create_station("Новгород")
          middle_station = @railway_controller.stations[1]
          stations_count_before = @railway_controller.routes[0].stations.length
          @railway_controller.add_station_to_route({
            station_index: 1,
            route_index:   0
          })
          expect(@railway_controller.routes[0].stations[1]).to eql(middle_station)
        end
      end #/При добавлении станции в маршурт
      
      context "При удалении станции из маршрута" do
        it "Станция удаляется из массива маршрута и недоступна по порядковому индексу" do
          @railway_controller.create_station("Новгород")
          middle_station = @railway_controller.stations[2]
          stations_count_before = @railway_controller.routes[0].stations.length
          @railway_controller.add_station_to_route({
            station_index: 1,
            route_index:   0 
          })
          @railway_controller.delete_station_from_route({
            route_index:   0
          })
          expect(@railway_controller.routes[0].stations[1]).to eql(@last_station)
        end
      end #/При удалении станции из маршрута

      context "При назначении маршрута поезду" do
        it "Маршрут становится значением переменной route поезда" do
          @train_number = "12345"
          @railway_controller.create_train(@train_number)
          @railway_controller.add_route_to_train({
            route_index:  0,
            train_number: @train_number
          })
          expect(@railway_controller.trains[@train_number].route).to eql(@railway_controller.routes[0])
        end
      end #/При назначении маршрута поезду
    end #При действии с маршрутами
    
    context "При движении поезда" do
      before(:each) do
        @train_number = "12345"
        @railway_controller = RailwayControl.new
        @railway_controller.create_train(@train_number)
        @railway_controller.create_station("Санкт-петербург")
        @railway_controller.create_station("Москва")
        @first_station = @railway_controller.stations.first
        @last_station = @railway_controller.stations.last
        @railway_controller.create_route({
          first_station_index: 0,
          last_station_index: 1
        })
        @railway_controller.add_route_to_train({
          route_index:  0,
          train_number: @train_number
        })
      end
      it "При перемещении вперёд, поезд перемещается на следующую станцию" do
        @next_station = @railway_controller.trains[@train_number].next_station
        @railway_controller.move_train_forward(@train_number) 
        expect(@railway_controller.trains[@train_number].current_station).to eql(@next_station)
      end
      it "При перемещении назад, поезд перемещается на предыдущую станцию" do
        @railway_controller.move_train_forward(@train_number) 
        @previous_station = @railway_controller.trains[@train_number].previous_station
        @railway_controller.move_train_backward(@train_number)
        expect(@railway_controller.trains[@train_number].current_station).to eql(@previous_station)
      end
    end #/При движении поезда
  end #/Использование
end
