=begin
Заполнить хеш гласными буквами, 
где значением будет являтся порядковый номер буквы в алфавите
(a - 1).
=end

english_alphabet = [
  'a', 'b', 'c', 'd', 'e', 'f', 'g',
  'h', 'i', 'j', 'k', 'l', 'm', 'n',
  'o', 'p', 'r', 's', 't', 'u', 'v',
  'w', 'x', 'y', 'z'
]

#исключил 'y'
english_vowels = ['a', 'e', 'i', 'o', 'u']

result_hash = {}
english_alphabet.each_with_index do |letter, index|
  vowels_hash[letter] = index if english_vowels.include?(letter)
end

puts result_hash
