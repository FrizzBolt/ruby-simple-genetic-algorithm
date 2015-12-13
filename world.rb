#TODO:
#-Rename a few methods
#-Figure out a way to implement mutation frequency
#-Write the game loop.
#-???
#-Profit


class World

  def initialize
    @goal_word = "cat"
    @mutation_frequency = ? #This will be implemented in the final game loop.
    @mutation_bucket = {0 => []}
    @@generation_counter = 0
    @reject_bin = []
    @initial_population = 10
  end

  def first_generation
    ##Creates 10 random 3 letter strings
    @initial_population.times { mutation_bucket[1] << Word.new("#{('a'..'z').to_a.shuffle[0,3].join}") }
    @@generation_counter += 1
  end

  def mutate(word)
    #Replaces a random letter in a given word with a new random letter
    Word.content.tr(word[rand(@goal_word.length)], (65 + rand(26)).chr.downcase)
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
    mutation_bucket[@@generation_counter].each {|word| evaluate_word(word)}
  end

  def sort_the_bucket
    mutation_bucket[@@generation_counter].sort_by {|word| word.fitness_score }.reverse!
  end

  def different_word?(word1, word2)
    word1.content != word2.content
  end

  def create_new_generation
    @@generation_counter += 1
    mutation_bucket[@@generation_counter] = []
  end

  def breed_candidates
    #Combines characters from two different words at random
    word1 = mutation_bucket.sample
    word2 = mutation_bucket.sample
    10.times do
      if different_word?(word1, word2)
        mutation_bucket[@@generation_counter] << breed(word1,word2)
      end
    end
  end

  def transfer_low_scores_to_reject_bin
    reject_bin << mutation_bucket[5...-1]
  end

  def delete_low_scores_from_bucket
    mutation_bucket = mutation_bucket[@@generation_counter].take(@initial_population / 3)
  end

  def end_at_goal
    mutation_bucket.each do |word, index|
      if word.fitness_score == @goal_word.length
        true
        break
      else
        false
      end
    end
  end

  def evolve
    #Still need to finish this. This will be the game loop.
  	first_generation
  	evaluate_all
  	sort_the_bucket
  	transfer_low_scores_to_reject_bin
  	delete_low_scores_from_bucket
  	create_new_generation
  	breed_candidates
  	@@generation_counter += 1
  	end_at_goal
  end

end
