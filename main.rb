#encoding: utf-8
require 'rubygems'
require 'sinatra'

set :sessions, true

helpers do
  def calculate_total(hand)
    total = 0
    hand.each do |card|
      if card[0] == 'A'
        total += 11
      elsif card[0].to_i == 0
        total +=10
      else
        total += card[0].to_i
      end
    end

    hand.select {|e| e[0] == "A"}.count.times do
      break if total <= 21
      total -=10
    end

    total
  end

  def is_blackjack(somebodys_hand,p)
    if calculate_total(somebodys_hand) == 21
      if p == 'player'
      @success = "Congrats you ve hit BlackJack!!" 
      @show_hit_or_stay = false
      else
        @success = "Sorry, dealer has hit blackjack!" 
        @show_hit_or_stay = false
      end
    end
  end

  def to_image(hand)
    imageholder = []
    imagename = ''
    hand.each do |card|
      case card[1]
      when '♠'
        imagename = 'spades_'
      when '♣'
        imagename = 'clubs_'
      when '♥'
        imagename = 'hearts_'
      when '♦'
        imagename = 'diamonds_'
      end

      
      if card[0] == 'J' 
        imagename += 'jack' 
      elsif card[0] == 'Q'
        imagename += 'queen'
      elsif card[0] == 'K'
        imagename += 'king'
      elsif card[0] == 'A'
        imagename += 'ace'
      elsif card[0].to_i.between?(2,10)
        imagename += card[0]
      end

      imageholder << imagename
    end
    imageholder
  end
  

end

before do 
  @show_hit_or_stay = true
end



get '/' do
  if session[:name]
    redirect '/bet'
  else
    redirect '/new_game'
  end
end

get '/new_game' do
  session[:stash] = 500
  erb :index
end

get '/bet' do
  session[:name] = params[:name]
  erb :bet
end


get '/game' do
  session[:stash] -= params[:bet].to_i
  values = ['2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K', 'A']
  suits = ['♠', '♣', '♥', '♦']
  session[:deck] = values.product(suits).shuffle!
  
  session[:player_hand] = []
  session[:dealer_hand] = []
  session[:game_state] = 'start'
  
  2.times do
    session[:dealer_hand] << session[:deck].pop
    session[:player_hand] << session[:deck].pop
  end
  
  @playershand = to_image(session[:player_hand])
  @dealershand = to_image(session[:dealer_hand])

  is_blackjack(session[:player_hand],'player')
  is_blackjack(session[:dealer_hand],'dealer')

  erb :game
end

post '/game/player/hit' do
  session[:player_hand] << session[:deck].pop
  
  if calculate_total(session[:player_hand]) > 21
    @error = "#{session[:name]}, looks like you bust!"
    @show_hit_or_stay = false
  end

  is_blackjack(session[:player_hand])

  erb :game
end

post '/game/player/stay' do
  @success = "#{session[:name]}, you've chosen to stay at #{calculate_total(session[:player_hand])}"
  @show_hit_or_stay = false
  erb :game
end

post '/end_game' do

end



