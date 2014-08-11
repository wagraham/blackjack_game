=begin 

A blackjack game begins with a deck of cards. A dealer then deals two cards
to himself and to the player. The players alternate turns and can either 
hit or stay. The dealer must stay at 17 or hit if he does not have 17. If the
dealer or player get 21, they win (blackjack); if a player goes over 21, he 
busts. If both players stay before 21, the player with the highest value wins.

What nouns might I extract to form classes? 

Players 
  - Dealer deals
  - Players alternate turns

Card (suit, value)

Deck (include values)
  - shows cards (inspect some element?)
  - define card names and values (mixed array? Hash?)
  - a hit can draw from the deck (sample from an array?)
  - compute value of player hands (here or in players?)

Game (the rules)
  - 21 wins (probably nead a way to compute value from deck)
  - 21+ busts
  - Winning conditions
  - ?

Game engine (Blackjack)
  - game loops
  - game has exit condition? 

=end 

require 'rubygems'
require 'pry'

class Card
  attr_accessor :suit, :face_value
  
  def initialize(s, fv) 
    @suit = s
    @face_value = fv #instance variables keep track of state of each object created from the class
  end

  def pretty_output #this is simply overwriting the to_s cmd that auto calls with puts
    puts "The #{face_value} of #{find_suit}"
  end

  def to_s #when to_s is auto called, it will now use pretty output
    pretty_output
  end 

  def find_suit
    ret_val = case suit
                when 'H' then 'Hearts'
                when 'D' then 'Diamonds'
                when 'S' then 'Spades'
                when 'C' then 'Clubs' 
              end  
    ret_val
  end
end

class Deck
  attr_accessor :cards

  def initialize
    @cards = []
    ['H', 'D', 'S', 'C'].each do |suit|
      ['2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K', 'A'].each do |face_value|
        @cards << Card.new(suit, face_value)
      end
    end
    scramble!
  end
  
  def scramble!
    cards.shuffle!
  end 

  def deal_one
    cards.pop
  end 

  def size
    cards.size
  end 
end

module Hand
  def show_hand
    puts "---- #{name}'s Hand ----"
    cards.each do|card|
      puts "=> #{card}"
    end
    puts "=>Total: #{total}"
  end

  def total
    face_values = cards.map{|card| card.face_value}

   total = 0
    face_values.each do |val|
      if val == "A"
        total += 11
      else
        total += (val.to_i == 0 ? 10 : val.to_i)
      end
    end

    #correct for Aces
    face_values.select{|val| val == "A"}.count.times do
      break if total <= 21
      total -= 10
    end
    
    total
  end

  def add_card(new_card)
    cards << new_card #it has access to getter cards, when you mix in the module to the Player class. 
  end 

  def is_busted?
    total > Blackjack::BLACKJACK_AMOUNT # if true, will return true = is busted
  end 

end

class Player
  include Hand

  attr_accessor :name, :cards

  def initialize(n)
    @name = n
    @cards = [] 
  end

  def show_flop
    show_hand
  end
end

class Dealer
  include Hand

  attr_accessor :name, :cards

  def initialize
    @name = "Dealer"
    @cards = [] 
  end 

  def show_flop
    puts "---- #{name}'s Hand ----"
    puts "=> First card is hidden"
    puts "=> second card is #{cards[1]}"
  end
end


class Blackjack
attr_accessor :deck, :player, :dealer

BLACKJACK_AMOUNT = 21
DEALER_HIT_MIN = 17

  def initialize
    @deck = Deck.new
    @player = Player.new("Player1")
    @dealer = Dealer.new
  end

  def set_player_name
    puts "What's your name?"
    player.name = gets.chomp #player class getter here; but player is object of Player class, which has a name setter method. Confusing!
  end

  def deal_cards
    player.add_card(deck.deal_one)
    dealer.add_card(deck.deal_one)
    player.add_card(deck.deal_one)
    dealer.add_card(deck.deal_one)
  end 

  def show_flop
    player.show_flop
    dealer.show_flop
  end

  def blackjack_or_bust?(player_or_dealer)
    if player_or_dealer.total == BLACKJACK_AMOUNT #though player/dealer are dif. classes, they can both respond to method .total; thus, this method will work. 
      if player_or_dealer.is_a?(Dealer)
        puts "Sorry, dealer hits blackjack. #{player.name} loses."
      else 
        puts "Congratulations, you hit blackjack! #{player.name} wins!"
      end
      play_again?
    elsif  player_or_dealer.is_busted?
      if player_or_dealer.is_a?(Dealer)
        puts "Congratulations, dealer busted. #{player.name} wins!"
      else
        puts "Sorry, #{player.name} busted. #{player.name} loses."
      end  
      play_again?
    end
  end


  def player_turn
    puts "{player.name}'s turn."

    blackjack_or_bust?(player)

    while !player.is_busted?
      puts "What would you like to do? 1) hit 2) stay"
      response = gets.chomp

      if !['1', '2'].include?(response)
        puts "Error: you must enter 1 or 2"
        next
      end

      if response == '2'
        puts "#{player.name} chose to stay"
        break
      end

      #hit
      new_card = deck.deal_one
      puts "Dealing card to #{player.name}: #{new_card}"
      player.add_card(new_card)
      puts "#{player.name}'s total is now: #{player.total}"

      blackjack_or_bust?(player)
    end
    puts "#{player.name} stays at #{player.total}"
  end    

  def dealer_turn
    puts "Dealer's turn."

    blackjack_or_bust?(dealer)
    while dealer.total < DEALER_HIT_MIN
      new_card = deck.deal_one
      puts "Dealing card to dealer: #{new_card}"
      dealer.add_card(new_card)
      puts "Dealer total is now: #{dealer.total}"

      blackjack_or_bust?(dealer)
    end
    puts "Dealer stays at #{dealer.total}."
  end

  def who_won? 
    if player.total > dealer.total
      puts "Congratulations, #{player.name} wins!"
    elsif player.total < dealer.total
      puts "Sorry, #{player.name} loses."
    else
      puts "It's a tie"
    end
    play_again? 
  end
      
  def play_again?
    puts ""
    puts "Would you like to play again? 1) yes 2) no, exit"
    if gets.chomp == '1'
      puts "Starting new game ..."
      puts ""
      deck = Deck.new #reset deck for new game
      player.cards = []
      dealer.cards = [] 
      start
    else
      puts "Goodbye!"
      exit
    end
  end    

  def start # write sequence first; use as guide to create methods!
    set_player_name
    deal_cards
    show_flop
    player_turn
    dealer_turn
    who_won?
  end
end

game = Blackjack.new
game.start


