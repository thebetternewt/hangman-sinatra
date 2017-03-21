module Dictionary

  def self.get_word
    dictionary = File.read 'lib/dictionary.txt'
    good_words = []
    dictionary.lines.each do |line|
      good_words << line.chomp if line.chomp.length.between?(5, 12)
    end
    good_words.sample
  end

end
