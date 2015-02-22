class LeaguesController < ApplicationController
  before_action :set_league, only: [:show, :edit, :update, :destroy, :start,
                                    :standings]

  # GET /leagues
  def index
    @leagues = League.all
  end

  # GET /leagues/1
  def show
    @league_teams = @league.teams if @league.present?
  end

  # GET /leagues/new
  def new
    @league = League.new
  end

  # GET /leagues/1/edit
  def edit
  end

  # POST /leagues
  def create
    @league = League.new(league_params)

    if @league.save
      redirect_to @league, notice: 'League was successfully created.'
    else
      render action: 'new'
    end
  end

  # PATCH/PUT /leagues/1
  def update
    if @league.update(league_params)
      redirect_to @league, notice: 'League was successfully updated.'
    else
      render action: 'edit'
    end
  end

  def start
    @league.start
    redirect_to standings_league_url(@league)
  end

  def standings

  end

  # DELETE /leagues/1
  def destroy
    @league.destroy
    redirect_to leagues_url, notice: 'League was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_league
      @league = League.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def league_params
      params.require(:league).permit(:name, :description, :start_date, :end_date)
    end
end
