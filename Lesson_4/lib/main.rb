require_relative 'railway_control'
require_relative 'railway_menu'


railway_controller = RailwayControl.new
menu = RailwayMenu.new

action_result = nil
loop do
  puts "Станций: #{railway_controller.stations.length} | Поездов: #{railway_controller.trains.length} | Маршрутов: #{railway_controller.routes.length}"
  puts "---"
  menu.print_menu
  print "Введите индекс действия: "
  action_index = gets.chomp.to_i
  railway_controller.clear_screen

  railway_controller.send menu.message(action_index) unless menu.action_menu[action_index].nil?
end
