# frozen_string_literal: true

class Speaking::AppearancesController < ApplicationController
  def index
    appearances = Appearance.includes(:appearance_type, :talk)
    @upcoming_appearances = appearances.upcoming.order(date: :asc)
    @past_appearances_by_year = appearances.past.order(date: :desc).group_by { |a| a.date.year }
  end

  def show
    @speaking_appearance = Appearance.friendly.find(params[:id])
  end
end
