=begin
Заполнить хеш гласными буквами, 
где значением будет являтся порядковый номер буквы в алфавите
(a - 1).
=end

english_alphabet = [
  'a', 'b', 'c', 'd', 'e',
  'f', 'g', 'h', 'i', 'j', 
  'k', 'l', 'm', 'n', 'o', 
  'p', 'r', 's', 't', 'u',
  'v', 'w', 'x', 'y', 'z'
]

#исключил 'y'
english_vowels = ['a', 'e', 'i', 'o', 'u']

vowels_order = {}
english_vowels.each do |vowel|
  if english_alphabet.index(vowel)
    vowels_order[vowel] = english_alphabet.index(vowel)+1
  end
end

puts vowels_order
