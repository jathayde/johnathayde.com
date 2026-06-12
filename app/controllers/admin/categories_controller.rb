# frozen_string_literal: true

class Admin::CategoriesController < ApplicationController
  layout "admin"
  before_action :authenticate_admin!
  before_action :set_category, only: %i[edit update destroy]

  def index
    @categories = Category.order(:name)
  end

  def new
    @category = Category.new
  end

  def edit
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      redirect_to admin_categories_url, notice: "Category was successfully created."
    else
      render :new, status: :unprocessable_content
    end
  end

  def update
    if @category.update(category_params)
      redirect_to admin_categories_url, notice: "Category was successfully updated."
    else
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    count = @category.articles.size
    if count.positive?
      label = count == 1 ? "1 article" : "#{count} articles"
      redirect_to admin_categories_url,
                  alert: "Cannot delete — #{label} still use this category."
    else
      @category.destroy
      redirect_to admin_categories_url, notice: "Category was successfully destroyed."
    end
  end

  private

  def set_category
    @category = Category.friendly.find(params[:id])
  end

  def category_params
    params.require(:category).permit(:name, :description)
  end
end
