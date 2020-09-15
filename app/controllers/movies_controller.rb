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
    if params[:title_sort] == 'on'
      session[:movie_highlight] = "hilite"
      session[:date_highlight] = ""
    elsif params[:date_sort] == 'on'
      session[:movie_highlight] = ""
      session[:date_highlight] = "hilite"
    end
    
    if params[:ratings] != nil
      @filtered_ratings = params[:ratings].keys
      session[:filtered_ratings] = @filtered_ratings
      @movies = Movie.with_ratings(@filtered_ratings)
    elsif session[:filtered_ratings] != nil
      @movies = Movie.with_ratings(session[:filtered_ratings])
    else
      @movies = Movie.all
    end
    @all_ratings = Movie.all_ratings
    
    if session[:movie_highlight] == "hilite"
      @movies = @movies.order(:title)
    elsif session[:date_highlight] == "hilite"
      @movies = @movies.order(:release_date)
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
