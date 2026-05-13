# frozen_string_literal: true

class Admin::AppearancesController < ApplicationController
  layout "admin"
  before_action :authenticate_admin!
  before_action :set_appearance, only: %i[show edit update destroy]

  def index
    appearances = Appearance.includes(:appearance_type, :talk)
    @upcoming_appearances = appearances.upcoming.order(date: :asc)
    @past_appearances = appearances.past.order(date: :desc)
  end

  def show
  end

  def new
    @appearance = Appearance.new
  end

  def edit
  end

  def create
    @appearance = Appearance.new(appearance_params)
    if @appearance.save
      redirect_to admin_appearance_url(@appearance), notice: "Appearance was successfully created."
    else
      render :new, status: :unprocessable_content
    end
  end

  def update
    if @appearance.update(appearance_params)
      redirect_to admin_appearance_url(@appearance), notice: "Appearance was successfully updated."
    else
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    @appearance.destroy
    redirect_to admin_appearances_url, notice: "Appearance was successfully destroyed."
  end

  private

  def set_appearance
    @appearance = Appearance.friendly.find(params[:id])
  end

  def appearance_params
    params.require(:appearance).permit(
      :event, :date, :location, :who, :what, :notes, :url, :slug,
      :speaker_deck_override, :appearance_type_id, :talk_id, :recording_id
    )
  end
end
