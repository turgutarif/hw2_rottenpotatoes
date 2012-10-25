class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end
 
  def index
    @all_ratings = Movie.ratings
    session[:ratings]= {'G'=>"1",'PG'=>"1",'PG-13'=>"1",'R'=>"1"}  if !session[:ratings] && !params[:ratings]
    redirect =false 
    [:srt_by,:ratings].each do |p|   
         if !params[p] && session[p]
           params[p] = session[p]; redirect=redirect||true
           session.delete p
         else  
            session[p] = params[p]
         end
    end
    if redirect
     flash.keep
     redirect_to  movies_path(params)
    end
    @movies = Movie.all(:conditions => {:rating => params[:ratings].keys})
    @movies = @movies.sort_by!{|m| m.send params[:srt_by]} if(params[:srt_by]) 
    
  end

  def new
    # default: render 'new' template
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
