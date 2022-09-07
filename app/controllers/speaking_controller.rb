class SpeakingController < ApplicationController
  def index
    @appearances = Appearance.upcoming
    @past_appearances = Appearance.past.order(date: :desc).limit(5)
  end
end
