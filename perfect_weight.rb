modificator = 110

print "Ваше имя: "
name = gets.chomp

print "Ваш рост: "
height = gets.chomp.to_f

perfect_weight = height - modificator

if perfect_weight > 0
	puts "#{name}, ваш идеальный вес #{perfect_weight} кг."
else
	puts "Ваш вес уже оптимальный"
end
