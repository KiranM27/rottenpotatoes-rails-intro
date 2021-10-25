class Movie < ActiveRecord::Base
  def self.all_ratings
    return ['G','PG','PG-13','R']
  end
  
  def self.with_ratings(ratings_list)
  # if ratings_list is an array such as ['G', 'PG', 'R'], retrieve all
  #  movies with those ratings
  # if ratings_list is nil, retrieve ALL movies
    return Movie.where(rating: ratings_list)
  end
  
  def self.sort(sort_type)
    if sort_type == "title"
      return Movie.order("title")
    elsif sort_type == "rdate"
      return Movie.order("release_date")
    end
  end
  
end
