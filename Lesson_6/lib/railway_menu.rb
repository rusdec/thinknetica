require_relative 'train'

class RailwayMenu

  attr_reader :action_menu, :exit_index
  
  def initialize
    @action_menu = [
      {
        message:  :create_station,
        title:    'Создать станцию',
        type:     :message,
      },
      {
        message:  :print_stations_only,
        title:    'Вывести список станций',
        type:     :message,
      },
      {
        message: :print_trains_on_station,
        title:   'Вывести список поездов на станции',
        type:     :message,
      },
      {
        type: :separator,
      },
      {
        message:  :create_route,
        title:    'Создать маршрут',
        type:     :message,
      },
      {
        message:  :print_routes_only,
        title:    'Вывести список маршрутов',
        type:     :message,
      },
      {
        message:  :add_station_to_route,
        title:    'Добавить станцию в маршрут',
        type:     :message,
      },
      {
        message:  :delete_station_from_route,
        title:    'Удалить станцию из маршрута',
        type:     :message,
      },
      {
        type: :separator
      },
      {
        message:  :create_train,
        title:    'Создать поезд',
        type:     :message,
      },
      {
        message:  :print_all_trains_only,
        title:    'Вывести список поездов',
        type:     :message,
      },
      {
        message:  :add_route_to_train,
        title:    'Назначать маршрут поезду',
        type:     :message,
      },
      {
        message:  :add_wagon_to_train,
        title:    'Прицепить вагон к поезду',
        type:     :message,
      },
      {
        message:  :delete_wagon_from_train,
        title:    'Отцепить вагон от поезда',
        type:     :message,
      },
      {
        message:  :move_train_forward,
        title:    'Переместить поезд по маршруту вперёд',
        type:     :message,
      },
      {
        message:  :move_train_backward,
        title:    'Переместить поезд по маршруту назад',
        type:     :message,
      },
      {
        type: :separator
      },
      {
        message:  :print_extended_statistic,
        title:    'Вывести статистику',
        type:     :message,
      },
      {
        type: :exit,
        title: 'Выход',
      },
    ]
    @exit_index = nil
  end

  def print_menu
    puts "Выберите действие:"
    self.action_menu.each_with_index do |item, index|
      case item[:type]
        when :separator
          puts
        when :exit
          @exit_index = index
          self.print_menu_item(index,item)
        else self.print_menu_item(index,item)
      end
    end
  end

  def print_menu_item(index, item)
    puts "[#{index}] #{item[:title]}"
  end

  def title(index)
    self.action_menu[index][:title]
  end

  def message(index)
    self.action_menu[index][:message]
  end

end
