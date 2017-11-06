class GamesController < ApplicationController
  def new
    @start_time = Time.now
    @letters = Array.new(5) { ('A'..'Z').to_a.sample }
  end

  def score
    @start_time = Time.parse(params[:start_time])
    @word = params[:new]
    @letters = params[:letter]
    @end_time = Time.now
    @total_time = @end_time - @start_time
    @result = {}
    if included?(@word.upcase, @letters)
      if english_word?(@word)
        @result[:score] = compute_score(@word, @total_time)
        @result[:message] = "Well done!"

      else
        @result[:score] = 0
        @result[:message] = "Not an english word"
      end
    else
      @result[:score] = 0
      @result[:message] = "Not in the grid"
    end
    return @result
  end

  def included?(guess, grid)
    guess.chars.all? { |letter| guess.count(letter) <= grid.count(letter) }
  end

  def compute_score(attempt, time_taken)
    time_taken > 60.0 ? 0 : attempt.size * (1.0 - time_taken / 60.0)
  end

  def english_word?(word)
    response = open("https://wagon-dictionary.herokuapp.com/#{word}").read
    json = JSON.parse(response)
    return json['found']
  end
end
