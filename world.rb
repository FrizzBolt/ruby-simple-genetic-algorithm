require_relative 'word'

class World

  def initialize
    @goal_word = "banana"
    @mutation_frequency = 2 #Maximum amount of mutations per generation
    @dna_storage = {1 => []}
    @@generation_counter = 1
    @rejected_candidates = []
    @generation_size = 100
  end

  def first_generation
    #Creates @generation_size.length amount of random 3 letter strings
    @generation_size.times { @dna_storage[1] << Word.new("#{('a'..'z').to_a.shuffle[0,@goal_word.length].join}") }
  end

  def mutate(word)
    #Replaces a random letter in a given word with a new random letter
    word_array = word.content.split("")
    word_array[rand(word_array.length)] = (65 + rand(26)).chr.downcase
    word.content = word_array.join("")
  end

  def pluck_word_and_mutate
    #Grabs a random word and runs a mutation on one of the letters. This is repeated the same amount of times as
    #the mutation frequency
    @mutation_frequency.times {mutate(@dna_storage[@@generation_counter].sample)}
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
    @dna_storage[@@generation_counter].map {|word| self.evaluate_word(word)}
  end

  def sort_storage
    #Sorts the bucket based on fitness score
    @dna_storage[@@generation_counter].sort_by! {|word| word.fitness_score }.reverse!
  end

  def different_word?(word1, word2)
    #Compares the content of two words
    word1.content != word2.content
  end

  def create_new_generation
    @@generation_counter += 1
    @dna_storage[@@generation_counter] = []
  end

  def breed_candidates
    #Combines characters from two different words at random
    @generation_size.times do
      word1 = @dna_storage[@@generation_counter - 1].sample
      word2 = @dna_storage[@@generation_counter - 1].sample
      if different_word?(word1, word2)
        @dna_storage[@@generation_counter] << breed(word1,word2)
      end
    end
  end

  def transfer_low_scores_to_rejected_candidates
    @rejected_candidates << @dna_storage[@@generation_counter][@generation_size...-1]
  end

  def delete_low_scores_from_storage
    @dna_storage[@@generation_counter] = @dna_storage[@@generation_counter].take(@generation_size / 4)
  end

  def end_at_goal
    @dna_storage[@@generation_counter].each do |word|
      if word.fitness_score == @goal_word.length
        true
      end
    end
  end

  def evolve_once
    pluck_word_and_mutate
  	evaluate_all
    sort_storage
  	delete_low_scores_from_storage
    create_new_generation
    breed_candidates
  end

  def evolve_complete
    until end_at_goal
      evolve_once
    end
  end

end
