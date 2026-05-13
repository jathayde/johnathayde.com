# frozen_string_literal: true

class Speaking::TalksController < ApplicationController
  def index
    @talks = Talk.order(:title)
  end

  def show
    @talk = Talk.friendly.find(params[:id])
    @appearances = @talk.appearances.order(date: :desc)
  end
end
