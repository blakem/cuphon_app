module ProfanityChecker
  class << self
    @@dictionary_file  = File.join(File.dirname(__FILE__), 'profanity_checker/dictionary.yml')
    @@dictionary       = YAML.load_file(@@dictionary_file)
    
    def is_profane?(word)
      return false if word.nil?
      profane_regexps.each do |regexp| 
        return true if word =~ regexp
      end
      word = word.strip.downcase
      return true if profane_word_hash[word]
      return true if BadWord.find_by_word(word)
      return false
    end
    
    def has_profane_word?(string)
      return false if string.nil?
      return true if BadWord.find_by_word(string)
      string.split.each do |word|
        return true if is_profane?(word)
      end
      return false
    end
  
    def profane_words
      @@dictionary.keys + %w(
        milf
        gayct
        gaylips
        suck
        sex
      )
    end
    
    def profane_regexps
      [/fuck/i, /shit/i]
    end
    
    def profane_word_hash
      Hash[profane_words.map {|x| [x, true]}]
    end 
  end 
end