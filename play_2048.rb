require_relative 'lib/2048.rb'

begin
  play

  say 'Would you like to play again? (Y/N)'
  play_again = gets.chomp.downcase

  until 'yn'.include?(play_again)
    puts
    puts 'Sorry, that is not a valid response.'
    say 'Would you like to play again? (Y/N)'
    play_again = gets.chomp.downcase
  end
end until play_again == 'n'
