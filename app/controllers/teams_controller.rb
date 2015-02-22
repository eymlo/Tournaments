class TeamsController < ApplicationController
  before_action :set_team, only: [:show, :edit, :update, :destroy]

  # GET /teams/1
  def show
  end

  # GET /teams/new
  def new
    @team = Team.new
  end

  # GET /teams/1/edit
  def edit
  end

  # POST /teams
  def create
    @team = Team.new(team_params)

    respond_to do |format|
      if @team.save
        format.html {
          redirect_to @team.league, notice: 'Team was successfully created.'
        }
        format.json {
          render :json => @team, :status => :created, :location => @team
        }
      else
        format.html { redirect_to @team.league }
        format.json {
          render :json => @team.errors, :status => :unprocessable_entity
        }
      end
    end
  end

  # PATCH/PUT /teams/1
  def update
    if @team.update(team_params)
      debugger
      redirect_to @team.league, notice: 'Team was successfully updated.'
    else
      render action: 'edit'
    end
  end

  # DELETE /teams/1
  def destroy
    respond_to do |format|
      @team.destroy
      format.html {
        debugger
        redirect_to league_url(@team.league), notice: 'Team was successfully destroyed.'
      }
      format.json {
        render :json => @team
      }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_team
      @team = Team.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def team_params
      params.require(:team).permit(:name, :league_id, :description)
    end
end
