require 'json'
require 'oauth'
require 'launchy'
require 'pry'
require './env'
require './lib/user'

 
def welcome
  puts "Welcome to the Epicodus Twitter client."
  @user = User.new
  puts 'To use TwitterCommandLine, you need to grant access to the app.'
  puts 'Press enter to launch your web browser and grant access.'
  gets
  Launchy.open @user.authorize_url
  puts 'Now, copy the PIN below and press enter:'
  oauth_verifier = gets.chomp
  @user.authorize!(oauth_verifier)
  # user.settings
  menu
end


def menu
  choice = nil
  until choice == 'x'
    puts "\nWhat would you like to do?"
    puts "Press 'v' to view tweets in your feed, 't' to send a tweet, 'f' to view who is following you, 'm' to view who you are following\
          or 'n' to follow a new account."
    puts "Press 'x' to exit."

    case choice = gets.chomp
    when 'v'
      results = @user.view_feed
      results.map {|tweet| puts "\n" + tweet }
    when 't'
      puts "\nWhat would you like to tweet: "
      update = gets.chomp
      @user.tweet(update)
      puts "\nHere is what you tweeted: "
      puts "#{update}"
    when 'f'
      puts "Here is a list people who are following you: "
      results = @user.followers
      results.map {|result| puts "\n" + result}
    when 'm'
      puts "Here is a list people who you follow: "
      results = @user.following
      results.map {|result| puts "\n" + result}
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