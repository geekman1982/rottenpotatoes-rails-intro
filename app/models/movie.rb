class Movie < ActiveRecord::Base
    
    def self.getAllRatings
        
        distinct_list = []
        Movie.select(:rating).distinct.each do | movie_item |
            distinct_list << movie_item.rating
        end
        
        return distinct_list
    end
    
    def self.findUsingRatings(rating_hash, sort_by)
       
        return_list = Movie.all
        unless (rating_hash == nil) || (rating_hash.empty?)
            return_list.where!( { rating: rating_hash.keys} )
        end
        
        return_list.order!(sort_by) unless (sort_by == nil)
        
        return return_list
    end
    
end
