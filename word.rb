require 'world'

class Word

  attr_reader :content
  attr_accessor :fitness_score

  def initialize(word)
    @content = word
    @fitness_score = 0
  end

end
