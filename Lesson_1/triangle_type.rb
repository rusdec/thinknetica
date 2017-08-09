puts "Узнаю треугольник по длинам его сторон"
puts

result_message = []

print "Длина первой стороны: "
first_side_length = gets.chomp.to_f

print "Длина второй стороны: "
second_side_length = gets.chomp.to_f

print "Длина третьей стороны: "
third_side_length = gets.chomp.to_f

result_message << "Треугольник:"

if (first_side_length == second_side_length) && (second_side_length == third_side_length)
  result_message << "равносторонний"

else

  if (first_side_length > second_side_length) && (first_side_length > third_side_length)
    hypotenuse = first_side_length
    cathetus_1 = second_side_length
    cathetus_2 = third_side_length

  elsif (second_side_length > first_side_length) && (second_side_length > third_side_length)
    hypotenuse = second_side_length
    cathetus_1 = first_side_length
    cathetus_2 = third_side_length

  else
    hypotenuse = third_side_length
    cathetus_1 = first_side_length
    cathetus_2 = second_side_length

  end

  result_message << "прямоуголный" if hypotenuse == Math.sqrt(cathetus_1**2 + cathetus_2**2)

  if cathetus_1 == cathetus_2
    result_message << "равнобедренный"

  else
    result_message << "разносторонний"

  end

end

puts result_message.join(" ")
