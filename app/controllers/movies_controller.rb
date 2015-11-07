class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    reset_session
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    must_redirect = false
    
    @all_ratings = Movie.getAllRatings
    
    @ratings_selected = params[:ratings]
    if (@ratings_selected == nil)
      if (session[:ratings] == nil)
        session[:ratings] = {}
        @all_ratings.each { |rating| session[:ratings][rating.to_sym] = "1"}
      end
      params[:ratings] = session[:ratings]
      must_redirect = true
    else
      session[:ratings] = @ratings_selected
    end
    
    @sort_by = params[:sort]
    if (@sort_by == nil)
      if not(session[:sort] == nil)
        params[:sort] = session[:sort]
        must_redirect = true
      else
        params[:sort] = nil
      end
    else
      session[:sort] = @sort_by
    end
    
    if (must_redirect)
      redirect_to(movies_path(params))
    else
      @movies = Movie.findUsingRatings(@ratings_selected, @sort_by)
    end

  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
