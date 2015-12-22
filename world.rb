# TODO:
# -Rename a few methods
# -Write the game loop.
# -???
# -Profit

class Word

  attr_reader :content
  attr_accessor :fitness_score

  def initialize(word)
    @content = word
    @fitness_score = 0
  end

end

class World

  def initialize
    @goal_word = "cat"
    @mutation_frequency = 1 #Maximum amount of mutations per generation
    @mutation_bucket = {1 => []}
    @@generation_counter = 1
    @reject_bin = []
    @generation_size = 30
  end

  def first_generation
    ##Creates 10 random 3 letter strings
    @generation_size.times { @mutation_bucket[1] << Word.new("#{('a'..'z').to_a.shuffle[0,3].join}") }
  end

  def mutate(word)
    #Replaces a random letter in a given word with a new random letter
    Word.content.tr(word[rand(@goal_word.length)], (65 + rand(26)).chr.downcase)
  end

  def pluck_word_and_mutate
    @mutation_frequency.times {mutate(@mutation_bucket[@@generation_counter].sample)}
  end

  def breed(word1, word2)
    #Combines letters for two words into a new word at random
    counter = 0
    word_array = [word1.content, word2.content]
    new_word = []
    @goal_word.length.times do
      new_word << word_array[rand(2)][counter]
      counter += 1
    end
    Word.new(new_word.join(""))
  end

  def evaluate_word(word)
    #Checks if the word contains any letters from the goal word and ups the fitness score if they do
    counter = 0
    until counter == word.content.length
      if word.content[counter] == @goal_word[counter]
        word.fitness_score += 1
      end
      counter += 1
    end
  end

  def evaluate_all
    #Evaluates all words in the generation
    @mutation_bucket[@@generation_counter].map {|word| self.evaluate_word(word)}
  end

  def first_generation_success?
    @mutation_bucket[1].each do |word|
      word.fitness_score > 0
    end
  end

  def sort_the_bucket
    @mutation_bucket[@@generation_counter].sort_by {|word| word.fitness_score }.reverse!
  end

  def different_word?(word1, word2)
    word1.content != word2.content
  end

  def create_new_generation
    @@generation_counter += 1
    @mutation_bucket[@@generation_counter] = []
  end

  def breed_candidates
    #Combines characters from two different words at random
    @generation_size.times do
      word1 = @mutation_bucket[@@generation_counter - 1].sample
      word2 = @mutation_bucket[@@generation_counter - 1].sample
      if different_word?(word1, word2)
        @mutation_bucket[@@generation_counter] << breed(word1,word2)
      end
    end
  end

  def transfer_low_scores_to_reject_bin
    @reject_bin << @mutation_bucket[@generation_size...-1]
  end

  def delete_low_scores_from_bucket
    @mutation_bucket = @mutation_bucket[@@generation_counter].take(@generation_size)
  end

  def end_at_goal
    @mutation_bucket[@@generation_counter].each do |word|
      if word.fitness_score == @goal_word.length
        true
      else
        false
      end
    end
  end

  def evolve
    #Still need to finish this. This will be the game loop.
    # first_generation
    # while end_at_goal == false
      rand(@mutation_frequency).times do |word|
        mutate(word)
      end
    	evaluate_all
      sort_the_bucket
    	transfer_low_scores_to_reject_bin
    	delete_low_scores_from_bucket
    	create_new_generation
    	breed_candidates
      puts @mutation_bucket[@@generation_counter]
    # end
  end
end

world = World.new
world.first_generation
world.evaluate_all
