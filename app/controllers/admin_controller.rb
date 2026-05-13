# frozen_string_literal: true

class AdminController < ApplicationController
  layout "admin"
  before_action :authenticate_admin!

  def index
    @stats = {
      appearances: Appearance.count,
      upcoming: Appearance.upcoming.count,
      past: Appearance.past.count,
      talks: Talk.count,
      recordings: Recording.count,
      appearance_types: AppearanceType.count,
      articles: Article.count,
      published_articles: Article.where.not(published_at: nil).count
    }
  end
end
