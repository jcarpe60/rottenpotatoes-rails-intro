class MoviesController < ApplicationController
  helper_method :selectedRating?
  helper_method :highlight

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
    
=begin
    if (params[:ratings].nil? && !session[:ratings].nil?) || (params[:order].nil? && !session[:order].nil?)
      redirect_to movies_path("ratings" => session[:ratings], "order" => session[:order])
    elsif !params[:ratings].nil? || !params[:order].nil?
      if !params[:ratings].nil?
        array_ratings = params[:ratings].keys
        return @movies = Movie.where(rating: array_ratings).order(session[:order])
      else
        return @movies = Movie.all.order(session[:order])
      end
    elsif !session[:ratings].nil? || !session[:order].nil?
      redirect_to movies_path("ratings" => session[:ratings], "order" => session[:order])
    else
      return @movies = Movie.all
    end
=end
    
    #if (params[:ratings].nil? && @selected.present?) || (params[:sort_by].nil? && @sorting.present?)
      #redirect_to movies_path("ratings" => @selected, "order" => @sorting)

    #if (params[:ratings].nil? && !session[:ratings].nil?) || (params[:sort_by].nil? && !session[:sort_by].nil?)
      #redirect_to movies_path("ratings" => session[:ratings], "order" => session[:sort_by])
    if !session[:ratings].nil? || !session[:sort_by].nil?
      if !session[:ratings].nil?
        return @movies = Movie.where(rating: session[:ratings].keys).order(session[:sort_by])
      else
        return @movies = Movie.all.order(session[:sorty_by])
      end
    elsif !params[:ratings].nil? || !params[:sort_by].nil?
      redirect_to movies_path("ratings" => session[:ratings], "order" => session[:sort_by])
    else
      return @movies = Movie.all
    end
    
  end

    
=begin
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
=end
    
  def highlight(column)
    if(session[:sort_by].to_s == column)
      return 'hilite'
    else
      return nil
    end
  end
  
  def selectedRating?(rating)
    selectedRatings = session[:ratings]
    return true if selectedRatings.nil?
    selectedRatings.include? rating
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
