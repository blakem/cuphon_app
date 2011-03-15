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
      (url, base) = self.short_url_and_base
      url
    end

    def short_url_and_base
      base = self.random_base
      url = "http://cphn.me/" + base
      if ShortUrl.find_by_url(base)
         self.short_url_and_base
      else
        ["http://cphn.me/" + base, base]
      end
    end
  end
end