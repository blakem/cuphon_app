require 'spec_helper'
require 'profanity_checker'

describe ProfanityChecker do
  describe "is_profane?" do
    it "should check words for profanity" do
      ProfanityChecker.is_profane?('MILF').should == true
      ProfanityChecker.is_profane?('MiLf').should == true
      ProfanityChecker.is_profane?('   MiLF    ').should == true
      ProfanityChecker.is_profane?('TastyMuffinSnacks').should == false
    end

    it "shouldn't crash on nil" do
      ProfanityChecker.is_profane?(nil).should == false      
    end
    
    it "should check for words in the dictionary" do
      ProfanityChecker.is_profane?('porn').should == true      
    end

    it "should check for anything that matches a certain pattern" do
      ProfanityChecker.is_profane?('blahblahFuckBlah').should == true      
    end

    it "should tag 'sex' as profane" do
      ProfanityChecker.is_profane?('sex').should == true      
    end
  end

  describe "has_profane_word?" do
    it "should check words for profanity" do
      ProfanityChecker.has_profane_word?('MILF').should == true
      ProfanityChecker.has_profane_word?('MiLf').should == true
      ProfanityChecker.has_profane_word?('   MiLF    ').should == true
      ProfanityChecker.has_profane_word?('TastyMuffinSnacks').should == false
      ProfanityChecker.has_profane_word?('This is a good test of TastyMuffinSnacks for you').should == false
      ProfanityChecker.has_profane_word?('This is a good test of TastyMuffinSnacks milf for you').should == true
    end

    it "shouldn't crash on nil" do
      ProfanityChecker.has_profane_word?(nil).should == false      
    end

  end
end