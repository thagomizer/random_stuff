require 'prime'

palindrome_primes = []

"1000".upto("9999").each do |prefix|
  prefix_reverse = prefix.reverse

  "0".upto("9").each do |middle|
    num = "#{prefix}#{middle}#{prefix_reverse}".to_i

    palindrome_primes << num if Prime.prime?(num)
  end
end

puts palindrome_primes.count
