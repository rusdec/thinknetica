require_relative 'train'

class RailwayMenu

  attr_reader :action_menu
  
  def initialize
    @action_menu = [
      {
        message:  :create_station,
        title:    'Создать станцию',
      },
      {
        message:  :print_stations,
        title:    'Вывести список станций',
      },
      {
        message: :print_trains_on_station,
        title:   'Вывести список поездов на станции',
      },
      {
        type: :separator,
      },
      {
        message:  :create_route,
        title:    'Создать маршрут',
      },
      {
        message:  :print_routes,
        title:    'Вывести список маршрутов',
      },
      {
        message:  :add_station_to_route,
        title:    'Добавить станцию в маршрут'
      },
      {
        message:  :delete_station_from_route,
        title:    'Удалить станцию из маршрута'
      },
      {
        type: :separator
      },
      {
        message:  :create_train,
        title:    'Создать поезд',
      },
      {
        message:  :print_all_trains,
        title:    'Вывести список поездов',
      },
      {
        message:  :add_route_to_train,
        title:    'Назначать маршрут поезду',
      },
      {
        message:  :add_wagon_to_train,
        title:    'Прицепить вагон к поезду',
      },
      {
        message:  :delete_wagon_from_train,
        title:    'Отцепить вагон от поезда',
      },
      {
        message:  :move_train_forward,
        title:    'Переместить поезд по маршруту вперед',
      },
      {
        message:  :move_train_backward,
        title:    'Переместить поезд по маршруту назад',
      },
      {
        type: :separator
      },
      {
        type: :exit
      },
    ]
  end

  def print_menu
    puts "Выберите действие:"
    self.action_menu.each_with_index do |item, index|
      if item.has_key?(:type) && item[:type] == :separator
        puts
      else
        puts "[#{index}] #{item[:title]}"
      end
    end
  end

  def title(index)
    self.action_menu[index][:title]
  end

  def message(index)
    self.action_menu[index][:message]
  end

  def clear_screen
    print "\e[2J\e[f"
  end

end
