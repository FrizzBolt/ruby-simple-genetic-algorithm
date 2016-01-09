
class Word

  attr_accessor :fitness_score, :content

  def initialize(word)
    @content = word
    @fitness_score = 0
  end

end
