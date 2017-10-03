=begin
Заданы три числа, которые обозначают число, месяц, год (запрашиваем у пользователя).
Найти порядковый номер даты, начиная отсчет с начала года. Учесть, что год может быть високосным.
(Запрещено использовать встроенные в ruby методы для этого вроде Date#yday или Date#leap?)
Алгоритм опредления високосного года:
Год високосный,
- если он делится на четыре без остатка,
- если он делится на 100 без остатка, это не високосный год.
- если он делится без остатка на 400, это високосный год. 
=end



print "Введите число: "
last_day = gets.chomp.to_i

print "Введите месяц: "
last_month = gets.chomp.to_i

print "Введите год: "
year = gets.chomp.to_i

is_leap = false
is_leap = true if ( ((year % 4 == 0) && (year % 100 != 0)) || (year % 400 == 0) )

days_total = 0

(1..last_month).each do |month|
  #последний месяц
  if (month == last_month)
    days = last_day
  #февраль
  elsif (month == 2)
    days = 28
    days += 1 if is_leap
  #чётность месяца и смена порядка в августе
  elsif ((month % 2 == 0 && month < 8) || (month % 2 != 0 && month >= 8))
    days = 30
  else
    days = 31
  end

  days_total += days
  #puts "Месяц №#{month}: #{days} (#{days_total})"
end

puts "Порядковый номер даты: #{days_total}"
