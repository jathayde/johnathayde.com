# frozen_string_literal: true

class Admin::Studio::GearItemsController < ApplicationController
  layout "admin"
  before_action :authenticate_admin!
  before_action :set_gear_item, only: %i[edit update destroy]

  def index
    grouped = Studio::GearItem.ordered.includes(:posts).group_by(&:category)
    @groups = Studio::GearItem.categories.keys.filter_map { |key| [key, grouped[key]] if grouped[key] }
  end

  def new
    @gear_item = Studio::GearItem.new(category: params[:category].presence || "misc")
    @gear_item.position = next_position(@gear_item.category)
  end

  def edit; end

  def create
    @gear_item = Studio::GearItem.new(gear_item_params)
    @gear_item.position = next_position(@gear_item.category) if gear_item_params[:position].blank?
    if @gear_item.save
      redirect_to admin_studio_gear_items_url, notice: "Gear item created."
    else
      render :new, status: :unprocessable_content
    end
  end

  def update
    if @gear_item.update(gear_item_params)
      redirect_to admin_studio_gear_items_url, notice: "Gear item updated."
    else
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    @gear_item.destroy
    redirect_to admin_studio_gear_items_url, notice: "Gear item deleted."
  end

  # Positions are per category: the sortable list on the index posts the ids
  # of one category group in their new order.
  def reorder
    Array(params[:ids]).each_with_index do |id, index|
      Studio::GearItem.where(id: id).update_all(position: index)
    end
    head :no_content
  end

  private

  def set_gear_item
    @gear_item = Studio::GearItem.friendly.find(params[:id])
  end

  def next_position(category)
    (Studio::GearItem.where(category: category).maximum(:position) || -1) + 1
  end

  def gear_item_params
    params.require(:studio_gear_item).permit(
      :name, :manufacturer, :category, :blurb, :affiliate_url, :position, :active
    )
  end
end
