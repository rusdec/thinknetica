=begin
Заполнить массив числами фибоначчи до 100
=end

def fibonacci(quantity, n_first=1, n_second=1)
  quantity -= 1
  return n_first + n_second if quantity <= 1
  fibonacci(quantity, n_second, n_first + n_second)  
end

array_of_fibonacci = []
(2..100).each do |number|
  array_of_fibonacci.push(fibonacci(number))
end

puts array_of_fibonacci
