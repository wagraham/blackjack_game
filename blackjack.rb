# Wyatt's Black Jack Game

# I. Pseudo-Code

  # A. I need to create a deck of cards that contains both cases
  # and values --- The Queen  must be valued at 10, for example. 

  # B. I must somehow distribute two cards to each player, 
  # a human and a computer

  # C. the program must calculate the sum of the values, and check for 
  # 21, bust, or option to hit and stay. 

  # D. the player must go first; then the dealer must play. 

  # E. the dealer must hit unless he has at least 17.

  # F. define a winner: 21, or if one person busts (< 21), 
  # or if both stay --- the person with the closest to 21 wins. 

  # G. print the winner and score. 

# II. Replacing Logic with Ruby

#A-B

def calculate_total(cards) 
# [['H', '2'], ['S', 'Q'], ... ]
  arr = cards.map{ |card| card[1] }     # I originally did the same thing over 4 lines of code; this is much easier.

  total = 0
  arr.each do |value|
    if value == "A"
      total +=11
    elsif value.to_i == 0
      total += 10 # because Jacks, Queens, and Kinds default to value 0; what about aces?
    else
      total += value.to_i
    end
  end

  # what about Aces?
  arr.select{|e| e == "A"}.count.times do
    if total > 21
      total -= 10
    end 
  end
  total # ruby returns value automatically
end

puts "Welcome to Blackjack!" 

suits = ['H', 'D', 'S', 'C']
cards = ['2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K', 'A']

deck = suits.product(cards)
deck.shuffle!

# Deal Cards

mycards = []
dealercards = []

mycards << deck.pop # I can pop off the end, because the cards are shuffled randomly. 
dealercards << deck.pop
mycards << deck.pop
dealercards << deck.pop

dealertotal = calculate_total(dealercards)
mytotal = calculate_total(mycards) 

# Show Cards - I should probably begin a while loop here

puts "Dealer has: #{dealercards[0]} and #{dealercards[1]}, for a total of #{dealertotal}"
puts "You have: #{mycards[0]} and #{mycards[1]}, for a total of #{mytotal}"
puts "" #to give space

#I suspect I need to loop the hit_or_stay method until someone wins

#my turn

if mytotal == 21
  puts "Blackjack! You win."
  exit
end

while mytotal < 21
  puts "What would you like to do? 1) hit 2) stay"
  hit_or_stay = gets.chomp

  if !['1', '2'].include?(hit_or_stay)
    puts "Error: you must choose either 1 or 2."
    next # continues the loop
  end

  if hit_or_stay == "2"
    puts "You chose to stay."
    break
  end
  
  #hit < no if condition to simplify things. If <21 evaluates to true and the prior two if conditions
  # evaluate to false, then this code runs.
  new_card = deck.pop
  puts "Dealing card to player: #{new_card}"
  mycards << new_card
  mytotal = calculate_total(mycards)
  puts "Your total is now #{mytotal}."

  if mytotal == 21
    puts "Blackjack!"
    exit
  elsif mytotal > 21
    puts "Sorry, you busted."
    exit
  end
end

# dealer turn

if dealertotal == 21
  puts "Dealer hit Blackjack. A loser is you!"
  exit
end

while dealertotal < 17 
  new_card = deck.pop # hit
  puts "Dealer hits: #{new_card}" # local variable within method scope can be reused
  dealercards << new_card
  dealertotal = calculate_total(dealercards)
  puts "Dealer total is now: #{dealertotal}"

  if dealertotal == 21
    Puts "Dealer hit Blackjack."

  elsif dealertotal > 21
    puts "Congrats. Dealer Busted. A winner is you"
  end
end
# compare hands

puts "Dealer's cards: "
dealercards.each do |card|
  puts " #{card}"
end

puts "You cards: "
mycards.each do |card|
  puts " #{card}"
end 

puts ""

if dealertotal > mytotal #except what if the dealer busted? This code is nicht güt. 
  puts "Sorry, dealer won"
elsif dealertotal < mytotal
  puts "You win!"
else 
  puts "It's a tie."
end

exit 

  






























