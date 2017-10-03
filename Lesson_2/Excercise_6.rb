=begin
  Сумма покупок. Пользователь вводит поочередно название товара,
цену за единицу и кол-во купленного товара (может быть нецелым числом).
Пользователь может ввести произвольное кол-во товаров до тех пор, пока
не введет "стоп" в качестве названия товара. На основе введенных данных требуетеся:

1. Заполнить и вывести на экран хеш, ключами которого являются названия товаров, а
значением - вложенный хеш, содержащий цену за единицу товара и кол-во купленного товара.
2. Также вывести итоговую сумму за каждый товар.
3. Вычислить и вывести на экран итоговую сумму всех покупок в "корзине".

=end

basket = {}
total_cost = 0.0;

#Заполнение корзины
loop do
  product = {}

  print "Название товара: "
  product['name'] = gets.chomp

  break if product['name'] == "стоп"
  
  print "Стоимость товара (за шт.): "
  product['cost'] = gets.chomp.to_f
  
  print "Количество товара (шт.): "
  product['amount'] = gets.chomp.to_f

  basket[product['name']] = {
    "cost" => product['cost'],
    "amount" => product['amount'],
  }
  
  total_cost += product['cost']*product['amount']
  puts    
end

#Вывод корзины
basket.each do |name, properties| 
  puts "--| \"#{name}\" |--"
  puts "Цена шт.: #{properties['cost']}"
  puts "Кол-во: #{properties['amount']}"
  puts "Итого: #{properties['cost']*properties['amount']}"
  puts
end

#puts basket
puts "\n---\nОбщая стоимость: #{total_cost}"
