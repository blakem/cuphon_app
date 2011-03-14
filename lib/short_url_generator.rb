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
      url = "http://cphn.me/" + random_base
      ShortUrl.find_by_url(url) ? self.short_url : url
    end
  end
end