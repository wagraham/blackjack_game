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
    puts "The #{@face_value} of #{@suit}"
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
    face_values = cards.map{ |card| card.face_value }

    total = 0
    face_values.each do |val|
    if val == "A"
      total +=11 #but it can also be one; see correction below. 
    elsif val.to_i == 0
      total += 10 # because Jacks, Queens, and Kinds default to value 0; what about aces?
    else
      total += val.to_i
    end
  
    #correct for Aces
    face_values.select{ |val| val == "A"}.count.times do
      break if total <= 21
      total -= 10
    end 

    total
  end
   
  end

  def add_card(new_card)
    cards << new_card #it has access to getter cards, when you mix in the module to the Player class. 
  end 

  def is_busted?
    total > 21 # if true, will return true = is busted
  end 

end

class Player
  include Hand

  attr_accessor :name, :cards

  def initialize(n)
    @name = n
    @cards = [] 
  end
end

class Dealer
  include Hand

  attr_accessor :name, :cards

  def initialize
    @name = "Dealer"
    @cards = [] 
  end 
end


deck = Deck.new

player = Player.new("Wyatt")
player.add_card(deck.deal_one)
player.add_card(deck.deal_one)
player.show_hand
#player.total

dealer = Dealer.new
dealer.add_card(deck.deal_one)
dealer.add_card(deck.deal_one)
dealer.show_hand
#dealer.total































#c1 = Card.new('H', '3') #.new on the class Card, creates on object. 
#Cards are objects created from a class, which object I can create by calling .new on the card class. 
#.new is also calling the initialize method from Card class. 
#c2 = Card.new('D', '4') #two objects; each have different states





=begin < < < my experiments

class Deck

deck = []
deck << [1,2,3,4,5,6,7,8,9,'Jack of', 'Queen of', 'King of', 'Ace of'].product(['Spades','Hearts','Clubs','Diamonds'])
deck.shuffle!

  def initialize; end

  def hit_or_stay
    if player 

end 



class Players

attr_accessor :player
attr_accessor :dealer 

  def initialize
  
  end

  def show_cards
    player_hand.inspect
    dealer_hand.inspect    
  end 



end

class GameRules

end

class BlackJack

end

=end 