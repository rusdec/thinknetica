require_relative 'railway_control'
require_relative 'railway_menu'

railway_controller = RailwayControl.new
menu = RailwayMenu.new

loop do
  railway_controller.print_short_statistic
  puts "---"
  menu.print_menu
  print "Введите индекс действия: "
  action_index = gets.chomp.lstrip.rstrip
  railway_controller.clear_screen

  next if action_index.empty?

  action_index = action_index.to_i
  break if action_index == menu.action_menu.length-1

  railway_controller.send menu.message(action_index) unless menu.action_menu[action_index].nil?
end
