class MoviesController < ApplicationController
  before_action :require_movie, only: [:show]

  def index
    if params[:query]
      data = MovieWrapper.search(params[:query])
    else
      data = Movie.all
    end

    render status: :ok, json: data
  end

  def show
    render(
      status: :ok,
      json: @movie.as_json(
        only: [:title, :overview, :release_date, :inventory],
        methods: [:available_inventory]
        )
      )
  end
def create
  newMovie = Movie.new(movie_params)

  if newMovie.save
    render json: {id: newMovie.id}
  else
    render_error(:bad_request, newMovie.errors.messages)
  end
end


  private

  def movie_params
    params.permit(:title, :overview, :release_date, :inventory, :external_id, :poster_path)
  end

  def require_movie
    @movie = Movie.find_by(title: params[:title])
    unless @movie
      render status: :not_found, json: { errors: { title: ["No movie with title #{params["title"]}"] } }
    end
  end
end
