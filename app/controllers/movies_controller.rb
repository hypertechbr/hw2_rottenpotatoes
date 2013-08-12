class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    
    sort = params[:sort]
    @sort = sort
    if (params[:sort])
      session[:sort] = sort
    end

    @filter_ratings = []
    @filter_ratings_hash = {}
    if (params[:ratings])# || session[:ratings])
       #if (!params[:ratings])
       # params[:ratings] = session[:ratings]
       #end

       params[:ratings].each_key { |keyr|
         @filter_ratings.push(keyr)
         @filter_ratings_hash[keyr] = keyr
       }
       @movies = Movie.find(:all, :order=>sort, :conditions => {:rating => @filter_ratings})
       session[:ratings] = @filter_ratings_hash
    else
       if (session[:ratings])
         flash.keep
         redirect_to movies_path(:sort=>session[:sort], :ratings=>session[:ratings])
       end
       @movies = Movie.all(:order=>sort)
    end

    @all_ratings = ['G','PG','PG-13','R']
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
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
