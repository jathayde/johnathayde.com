class Speaking::AppearancesController < ApplicationController
  before_action :set_speaking_appearance, only: %i[ show edit update destroy ]

  # GET /speaking/appearances or /speaking/appearances.json
  def index
    @speaking_appearances = Appearance.all.order(date: :desc)
  end

  # GET /speaking/appearances/1 or /speaking/appearances/1.json
  def show
  end

  # GET /speaking/appearances/new
  def new
    @speaking_appearance = Appearance.new
  end

  # GET /speaking/appearances/1/edit
  def edit
  end

  # POST /speaking/appearances or /speaking/appearances.json
  def create
    @speaking_appearance = Appearance.new(speaking_appearance_params)

    respond_to do |format|
      if @speaking_appearance.save
        format.html { redirect_to speaking_appearance_url(@speaking_appearance), notice: "Appearance was successfully created." }
        format.json { render :show, status: :created, location: @speaking_appearance }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @speaking_appearance.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /speaking/appearances/1 or /speaking/appearances/1.json
  def update
    respond_to do |format|
      if @speaking_appearance.update(speaking_appearance_params)
        format.html { redirect_to speaking_appearance_url(@speaking_appearance), notice: "Appearance was successfully updated." }
        format.json { render :show, status: :ok, location: @speaking_appearance }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @speaking_appearance.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /speaking/appearances/1 or /speaking/appearances/1.json
  def destroy
    @speaking_appearance.destroy

    respond_to do |format|
      format.html { redirect_to speaking_appearances_url, notice: "Appearance was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_speaking_appearance
      @speaking_appearance = Appearance.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def speaking_appearance_params
      params.fetch(:speaking_appearance, {})
    end
end
