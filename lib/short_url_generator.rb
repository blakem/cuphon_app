module ShortUrlGenerator
  class << self
    def random_base
      random_letter() + random_letter() + random_letter() + random_letter() + random_letter()
    end
    
    def random_letter
      list = ("a".."z").to_a + (0..9).to_a
      list[rand(list.length)].to_s
    end
    
    def short_url
      "http://cphn.me/" + random_base
    end
  end
end