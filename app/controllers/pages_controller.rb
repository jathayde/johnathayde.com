# frozen_string_literal: true

class PagesController < ApplicationController
  layout 'placeholder', only: :placeholder

  def index; end

  def resume; end

  def placeholder; end
end
