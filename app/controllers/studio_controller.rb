# frozen_string_literal: true

class StudioController < ApplicationController
  def index
    @posts = Studio::Post.visible_on_index.includes(hero_image_attachment: :blob)
  end

  def gear
    @groups = Studio::GearItem.grouped_for_display
    @featured_in = featured_in_map(@groups.flat_map(&:last))
  end

  def show
    @post = Studio::Post.friendly.find(params[:slug])
    raise ActiveRecord::RecordNotFound unless @post.live? || admin?

    @audio_samples = @post.audio_samples.includes(file_attachment: :blob)
    # Signal-chain order (category), then the manual order within it.
    category_order = Studio::GearItem.categories.keys
    @gear_items = @post.gear_items.active.sort_by { |item| [category_order.index(item.category), item.position, item.name] }
  end

  private

  # { gear_item_id => [live posts] } in one query, for the "featured in" links.
  def featured_in_map(items)
    joins = Studio::PostGearItem.where(gear_item_id: items.map(&:id))
                                .joins(:post).merge(Studio::Post.live)
                                .includes(:post)
    joins.group_by(&:gear_item_id).transform_values { |rows| rows.map(&:post).uniq.sort_by(&:published_at).reverse }
  end
end
