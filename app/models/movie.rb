class Movie < ActiveRecord::Base
    
  def self.all_ratings
    ratings= Array.new
    self.select(:rating).distinct.each {|x| ratings.push(x.rating)}
    ratings
  end
  
  def self.with_ratings(filtered_ratings)
    filtered_movies = self.all.where({rating: filtered_ratings})
    filtered_movies
  end
  
end
