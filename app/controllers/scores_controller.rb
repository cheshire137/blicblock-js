class ScoresController < ApplicationController
  before_action :set_score, only: [:show]
  respond_to :json

  # GET /scores.json
  def index
    @scores = Score.order_by_value.limit(100)
  end

  # GET /scores/1.json
  def show
  end

  # POST /scores.json
  def create
    @score = Score.new(score_params)
    @score.ip_address = request.remote_ip
    if @score.save
      render :show, status: :created, location: @score
    else
      render json: @score.errors, status: :unprocessable_entity
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
