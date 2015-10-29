class Movie < ActiveRecord::Base
    def self.all_ratings
        ratings = []
        Movie.all.each do |movie|
            if (ratings.find_index(movie.rating) == nil)
                ratings.push(movie.rating)
            end
        end
        return ratings
    end
end
