class MoviesController < ApplicationController
  helper_method :chosen_rating?
  helper_method :hilight

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end
  
  #index: true #if !@selected.nil? ? @selected.include?(rating) : true

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  
  def index
    @all_ratings = Movie.all_ratings

    #debugger
    session[:ratings] = params[:ratings] unless params[:ratings].nil?
    session[:sort_by] = params[:sort_by] unless params[:sort_by].nil?
    
    @selected = session[:ratings]
    @sorting = session[:sort_by]
    
    #if (params[:ratings].nil? && !session[:ratings].nil?) || (params[:order].nil? && !session[:order].nil?)
      #redirect_to movies_path("ratings" => session[:ratings], "order" => session[:order])
    #elsif !session[:ratings].nil? || !session[:order].nil?
      #redirect_to movies_path("ratings" => session[:ratings], "order" => session[:sort_by])
    
    if @selected.present? && @sorting.present?
      @movies, @class1, @class2 = case params[:sort_by]
      when "title"
        [Movie.where(rating: @selected.keys).order(@sorting), "hilite", "not"]
      when "release_date"
        [Movie.where(rating: @selected.keys).order(@sorting), "not", "hilite"]
      else
        [Movie.all, "not", "not"]
      end 
    elsif @selected.present? && @sorting.nil?
      @movies = Movie.where(rating: @selected.keys)
    elsif @selected.nil? && @sorting.present?
      @movies, @class1, @class2 = case @sorting
      when "title"
        [Movie.all.order(@sorting), "hilite", "not"]
      when "release_date"
        [Movie.all.order(@sorting), "not", "hilite"]
      else
        [Movie.all, "not", "not"]
      end 
    else
      @movies = Movie.all
    end
  end
    
  def hilight(column)
    if(session[:sort_by].to_s == column)
      return 'hilite'
    else
      return nil
    end
  end
  
  def chosen_rating?(rating)
    chosen_ratings = session[:ratings]
    return true if chosen_ratings.nil?
    chosen_ratings.include? rating
  end
    
=begin
    if params[:ratings].present?
      @movies = Movie.where(rating: params[:ratings].keys)
    else
      @movies = Movie.all
    end
=end
=begin
    if params[:ratings].present? && params[:sort_by].present?
      @movies, @class1, @class2 = case params[:sort_by]
      when "title"
        [Movie.where(rating: params[ratings].keys).order(params[:sort_by]), "hilite", "not"]
      when "release_date"
        [Movie.where(rating: params[ratings].keys).order(params[:sort_by]), "not", "hilite"]
      else
        [Movie.all, "not", "not"]
      end 
    elsif params[:ratings].present? && params[:sort_by].nil?
      @movies = Movie.where(rating: params[:ratings].keys)
    elsif params[:ratings].nil? && params[:sort_by].present?
      @movies, @class1, @class2 = case params[:sort_by]
      when "title"
        [Movie.all.order(params[:sort_by]), "hilite", "not"]
      when "release_date"
        [Movie.all.order(params[:sort_by]), "not", "hilite"]
      else
        [Movie.all, "not", "not"]
      end 
    else
      @movies = Movie.all
    end
=end

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
