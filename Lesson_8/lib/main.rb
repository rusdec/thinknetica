require_relative 'railway_control'
require_relative 'railway_menu'

railway_controller = RailwayControl.new
menu = RailwayMenu.new

railway_controller.clear_screen
loop do
  railway_controller.print_short_statistic
  puts '---'
  menu.print_menu
  print 'Введите индекс действия: '
  action_index = gets.chomp.strip
  railway_controller.clear_screen

  next if action_index.empty?

  action_index = action_index.to_i
  break if action_index == menu.exit_index

  next if menu.action_menu[action_index].nil? || menu.message(action_index).nil?

  begin
    result = railway_controller.public_send menu.message(action_index)
  rescue StandardError => error
    railway_controller.clear_screen
    puts "Ошибка: #{error.backtrace.inspect}"
  else
    railway_controller.clear_screen
    puts result
  end
end
