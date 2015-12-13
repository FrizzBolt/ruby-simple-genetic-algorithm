
##USE GENETIC ALGORITHM TO EVOLVE TO A DRUM BEAT. FEED THAT DATA BACK INTO FL. OVER EACH GENERATION SLOWLY FORMING INTO THE DRUM BEAT

class World

  attr_accessor :mutation_bucket

  def initialize
    @goal_word = "cat"
    @mutation_frequency = ?
    @mutation_bucket = {0 => []}
    @@generation_counter = 0
    @reject_bin = []
    @initial_population = 10
  end

  def first_generation
    ##Creates 10 random 3 letter strings
    @initial_population.times { mutation_bucket[0] << Word.new("#{('a'..'z').to_a.shuffle[0,3].join}") }
    @@generation_counter += 1
  end

  def mutate(word)
    #Replaces a random letter in a given word with a new random letter
    Word.content.tr(word[rand(@goal_word.length)], (65 + rand(26)).chr.downcase)
  end

  def breed(word1, word2)
    #Combines letters for two words into a new word at random
    counter = 0
    word_array = [word1, word2]
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
    until counter == word.length
      if word[counter] == @goal_word[counter]
        word.fitness_score += 1
      end
      counter += 1
    end
  end

  def evaluate_all
    mutation_bucket.each {|word| evaluate_word(word)}
  end

  def sort_the_bucket
    mutation_bucket[@@generation_counter].sort_by {|word| word.fitness_score }.reverse!
  end

  def different_word?(word1, word2)
    word1 != word2
  end

  def create_new_generation
    @@generation_counter += 1
    mutation_bucket[@@generation_counter] = []
  end

  def breed_candidates
    word1 = mutation_bucket.sample
    word2 = mutation_bucket.sample
    10.times do
      if different_word?(word1, word2)
        mutation_bucket[@@generation_counter] << breed(word1,word2)
      end
    end
    create_new_generation
  end

  def transfer_low_scores_to_reject_bin
    reject_bin << mutation_bucket[5...-1]
  end

  def delete_low_scores_from_bucket
    mutation_bucket = mutation_bucket.take(@initial_population / 3)
  end

  def end_at_goal
    mutation_bucket.each do |x, index|
      break if x == @fitness_score
    end
  end

  def evolve
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

    # Initialization - Create an initial population. This population is usually randomly generated and can be any desired size, from only a few individuals to thousands.
    # Evaluation - Each member of the population is then evaluated and we calculate a 'fitness' for that individual. The fitness value is calculated by how well it fits with our desired requirements. These requirements could be simple, 'faster algorithms are better', or more complex, 'stronger materials are better but they shouldn't be too heavy'.
    # Selection - W e want to be constantly improving our populations overall fitness. Selection helps us to do this by discarding the bad designs and only keeping the best individuals in the population.  There are a few different selection methods but the basic idea is the same, make it more likely that fitter individuals will be selected for our next generation.
    # Crossover - During crossover we create new individuals by combining aspects of our selected individuals. We can think of this as mimicking how sex works in nature. The hope is that by combining certain traits from two or more individuals we will create an even 'fitter' offspring which will inherit the best traits from each of it's parents.
    # Mutation - We need to add a little bit randomness into our populations' genetics otherwise every combination of solutions we can create would be in our initial population. Mutation typically works by making very small changes at random to an individuals genome.
    # And repeat! - Now we have our next generation we can start again from step two until we reach a termination condition.

end
