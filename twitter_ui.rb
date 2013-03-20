
require 'oauth'
require 'launchy'
require './env'
require './lib/user'
 
CALLBACK_URL = 'oob'
 



def welcome
  puts "Welcome to the Epicodus Twitter client."
  user = User.new
  puts 'To use TwitterCommandLine, you need to grant access to the app.'
  puts 'Press enter to launch your web browser and grant access.'
  gets
  Launchy.open user.authorize_url
  puts 'Now, copy the PIN below and press enter:'
  oauth_verifier = gets.chomp
  user.authorize!(oauth_verifier)
  menu
end

def menu
  choice = nil
  until choice == 'x'
    puts "What would you like to do?"
    puts "Press 'v' to view tweets in your timeline, 't' to send a tweet, 'f' to view who is following you, 'm' to view who you are following\
          or 'n' to follow a new account."
    puts "Press 'x' to exit."

    case choice = gets.chomp
    when 'v'
      view_timeline
    when 't'
      tweet
    when 'f'
      view_followers
    when 'm'
      view_following
    when 'n'
      follow_new
    when 'x'
      exit
    else
      invalid
    end
  end
end




welcome