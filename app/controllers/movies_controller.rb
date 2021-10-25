class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    # @movies = Movie.all
    @all_ratings = Movie.all_ratings
    @ratings_to_show_hash = params[:ratings] || session[:ratings] || select_all_hash
    @ratings_to_show = ratings_to_show
    @movies = Movie.with_ratings(@ratings_to_show)
    
    if params[:sort].nil?
      unless session[:sort].nil?
        params[:sort] = session[:sort]
      end
    end      
        
    unless params[:sort].nil?
      @movies = @movies.sort(params[:sort])
      @sort = params[:sort]
    end
    
    session[:sort] = @sort
    session[:ratings] = @ratings_to_show_hash
    
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

  private
  # Making "internal" methods private is not required, but is a common practice.
  # This helps make clear which methods respond to requests, and which ones do not.
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end
  
  def ratings_to_show
    return @ratings_to_show_hash.keys
  end
  
  def select_all_hash
    return Hash[@all_ratings.map{|rating| [rating,"1"]}]
  end
end
