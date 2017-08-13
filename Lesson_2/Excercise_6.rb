basket = {}
total_cost = 0.0;

loop do
  product = {}

  print "Название товара: "
  product['name'] = gets.chomp

  break if product['name'] == "стоп"

  print "Стоимость товара (за шт.): "
  product['cost'] = gets.chomp.to_f
  
  print "Количество товара (шт.): "
  product['amount'] = gets.chomp.to_f

  total_cost_for_product = product['cost']*product['amount'];

  basket[product['name']] = {
    "Цена ед. товара" => product['cost'],
    "Кол-во ед. товара" => product['amount'],
    "Цена общая" => total_cost_for_product,
  }
  
  total_cost += total_cost_for_product
  puts    
end

puts basket
puts "Стоимость итого: #{total_cost}"
