=begin
Заполнить массив числами от 10 до 100 с шагом 5
=end

array = []
(10..100).each { |number| array.push(number) if number%5 == 0 }

puts array
