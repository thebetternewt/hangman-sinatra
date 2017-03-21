class Player

  def guess_letter
    input = ''
    loop do
      puts "Enter a letter:"
      print ">> "
      input = $stdin.gets.chomp
      break if valid_letter?(input)
    end
    input.upcase
  end

  private

  def valid_letter?(input)
    if input =~ /^[A-Za-z]$/
      true
    else
      puts "Invalid input!"
      false
    end
  end

end
