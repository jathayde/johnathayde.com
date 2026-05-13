# frozen_string_literal: true

class Admin::TalksController < ApplicationController
  layout "admin"
  before_action :authenticate_admin!
  before_action :set_talk, only: %i[show edit update destroy]

  def index
    @talks = Talk.order(:title)
  end

  def show
    @appearances = @talk.appearances.order(date: :desc)
  end

  def new
    @talk = Talk.new
  end

  def edit
  end

  def create
    @talk = Talk.new(talk_params)
    if @talk.save
      redirect_to admin_talk_url(@talk), notice: "Talk was successfully created."
    else
      render :new, status: :unprocessable_content
    end
  end

  def update
    if @talk.update(talk_params)
      redirect_to admin_talk_url(@talk), notice: "Talk was successfully updated."
    else
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    @talk.destroy
    redirect_to admin_talks_url, notice: "Talk was successfully destroyed."
  end

  private

  def set_talk
    @talk = Talk.friendly.find(params[:id])
  end

  def talk_params
    params.require(:talk).permit(:title, :subtitle, :description, :speaker_deck_embed)
  end
end
