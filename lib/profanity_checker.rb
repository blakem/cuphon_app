module ProfanityChecker
  class << self
    @@dictionary_file  = File.join(File.dirname(__FILE__), 'profanity_checker/dictionary.yml')
    @@dictionary       = YAML.load_file(@@dictionary_file)
    
    def is_profane?(word)
      return false if word.nil?
      words = self.profane_words
      profane_word_hash[word.strip.downcase] || false
    end
    
    def has_profane_word?(string)
      return false if string.nil?
      string.split.each do |word|
        return true if is_profane?(word)
      end
      return false
    end
  
    def profane_words
      @@dictionary.keys + %w(
        milf
      )
    end
    
    def profane_word_hash
      Hash[profane_words.map {|x| [x, true]}]
    end 
  end 
end