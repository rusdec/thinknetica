=begin
Заполнить массив числами от 10 до 100 с шагом 5
=end

numbers = []
(10..100).each { |number| numbers.push(number) if number%5 == 0 }

puts numbers
