puts "Нахождение корней квадратного уравнения"
puts

print "Задайте коэффициент a: "
a = gets.chomp.to_f
print "Задайте коэффициент b: "
b = gets.chomp.to_f
print "Задайте коэффициент c: "
c = gets.chomp.to_f
puts

discriminant = b**2.0 - 4.0*a*c

if discriminant > 0
  discriminant = Math.sqrt(discriminant)
  first_root  = (-b + discriminant)/(2.0*a)
  second_root = (-b - discriminant)/(2.0*a)
  puts "Значение первого корня #{first_root}"
  puts "Значение второго корня #{second_root}"

elsif discriminant == 0
  puts "Корни равны. Их значение #{-b/(2.0*a)}"

else
  puts "Корни - мнимые числа."

end
