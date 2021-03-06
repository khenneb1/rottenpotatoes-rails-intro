class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index

    @all_ratings = Movie.all_ratings    
    @sort = params[:sort] || session[:sort]
    
    params_ratings_bool = !(params[:ratings].nil?) && params[:ratings].is_a?(Hash) && params[:commit] == "Refresh"
    @ratings = params_ratings_bool ? params[:ratings].keys : (session[:ratings] || @all_ratings)
    
    @movies = Movie.with_ratings(@ratings, @sort)
    
    if params[:sort] != session[:sort] || params[:ratings] != session[:ratings]
      session[:sort] = @sort
      session[:ratings] = @ratings
    end
    
    if (params[:sort].nil? and !(session[:sort].nil?)) or (params[:ratings].nil? and !(session[:ratings].nil?))
      flash.keep
      redirect_to movies_path(sort: @sort, ratings: @ratings)
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
  
  helper_method :hilite
  def hilite header_title 
    "hilite" if @sort == header_title
  end
  
end
