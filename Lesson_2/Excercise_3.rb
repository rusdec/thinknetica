=begin
Заполнить массив числами фибоначчи до 100
=end

def fibonacci(quantity, n_first=0, n_second=1)
  quantity -= 1
  return n_first + n_second if quantity <= 1
  fibonacci(quantity, n_second, n_first + n_second)  
end

fibonacci_numbers = []
(1..100).each do |number|
  fibonacci_numbers << fibonacci(number)
  puts "#{number}: #{fibonacci_numbers[number-1]}"
end
