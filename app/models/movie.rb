class Movie < ActiveRecord::Base
    def self.all_ratings
        ['G', 'PG', 'PG-13','R']
    end
    
    def self.with_ratings(ratings, sort) 
        return Movie.all.order(sort) if (ratings.nil? or ratings.empty?)
        Movie.where(rating: ratings).order(sort)
    end
end
