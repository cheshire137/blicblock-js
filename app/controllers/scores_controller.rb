class ScoresController < ApplicationController
  before_action :set_score, only: [:show]
  respond_to :json

  # GET /scores.json
  def index
    @ip_address = request.remote_ip
    @scores = Score
    if params[:order] == 'newest'
      @scores = @scores.order_by_newest
    elsif params[:order] == 'oldest'
      @scores = @scores.order_by_oldest
    else
      @scores = @scores.order_by_value
    end
    if params[:time] == 'week'
      @scores = @scores.this_week
    elsif params[:time] == 'month'
      @scores = @scores.this_month
    end
    if (initials=params[:initials]).present?
      @scores = @scores.where(initials: initials.strip.upcase)
    end
    @scores = @scores.limit(25)
  end

  # GET /scores/1.json
  def show
  end

  # POST /scores.json
  def create
    @score = Score.new(score_params)
    @score.ip_address = request.remote_ip
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
    @score = Score.find(params[:id])
  end

  def score_params
    params.require(:score).permit(:initials, :value, :latitude, :longitude)
  end
end
