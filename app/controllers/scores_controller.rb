class ScoresController < ApplicationController
  before_action :set_score, only: [:show]
  respond_to :json

  # GET /api/scores.json
  def index
    @scores = Score.ranked
    sort_scores
    filter_scores_by_time
    filter_scores_by_initials
    filter_scores_by_country
    paginate_scores
  end

  # GET /api/scores/countries.json
  def countries
    @scores = Score
    filter_scores_by_time
    filter_scores_by_initials
    filter_scores_by_country
    location_ids = @scores.pluck(:location_id)
    @location_score_counts = {}
    location_ids.each do |id|
      @location_score_counts[id] ||= 0
      @location_score_counts[id] += 1
    end
    @locations = Location.where(id: location_ids.uniq).order(:country)
  end

  # GET /api/scores/1.json
  def show
    @total_scores = Score.count
  end

  # POST /api/scores.json
  def create
    @score = Score.new(score_params)
    @score.location = Location.for_ip_address(request.remote_ip)
    if @score.save
      @total_scores = Score.count
      render :show, status: :created, location: @score
    else
      render json: {error: @score.errors.full_messages.join(', ')},
             status: :unprocessable_entity
    end
  end

  private

  def set_score
    @score = Score.ranked.find(params[:id])
  end

  def score_params
    params.require(:score).permit(:initials, :value)
  end

  def sort_scores
    if params[:order] == 'newest'
      @scores = @scores.order_by_newest
    elsif params[:order] == 'oldest'
      @scores = @scores.order_by_oldest
    elsif params[:order] == 'initials'
      @scores = @scores.order(:initials)
    else
      @scores = @scores.order_by_value
    end
  end

  def filter_scores_by_time
    if params[:time] == 'week'
      @scores = @scores.last_seven_days
    elsif params[:time] == 'month'
      @scores = @scores.last_thirty_days
    end
  end

  def filter_scores_by_initials
    if (initials=params[:initials]).present?
      @scores = @scores.where(initials: initials.strip.upcase)
    end
  end

  def filter_scores_by_country
    if (country_codes=params[:country_codes]).present?
      @scores = @scores.in_country(country_codes.split(','))
    elsif (country_code=params[:country_code]).present?
      @scores = @scores.in_country([country_code])
    end
  end

  def paginate_scores
    page = (params[:page].presence || 1).to_i
    page = 1 if page < 1
    @scores = @scores.paginate(page: page, per_page: 20)
  end
end
