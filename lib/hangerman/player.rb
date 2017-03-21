class Player

  def guess_letter
    # input = ''
    # loop do
      puts "Pick a letter:"
      print ">> "
      input = $stdin.gets.chomp
      # break if valid_letter?(input)
    # end
    input.upcase
  end

  private

  def valid_letter?(input)
    if input =~ /^[A-Z]$|^save$|^load$|/i
      true
    else
      puts "Invalid input!"
      false
    end
  end

end
