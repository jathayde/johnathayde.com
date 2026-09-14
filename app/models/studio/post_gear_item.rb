# frozen_string_literal: true

# == Schema Information
#
# Table name: studio_post_gear_items
#
#  id           :bigint           not null, primary key
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  gear_item_id :bigint           not null
#  post_id      :bigint           not null
#
# Indexes
#
#  index_studio_post_gear_items_on_gear_item_id              (gear_item_id)
#  index_studio_post_gear_items_on_post_id                   (post_id)
#  index_studio_post_gear_items_on_post_id_and_gear_item_id  (post_id,gear_item_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (gear_item_id => studio_gear_items.id)
#  fk_rails_...  (post_id => studio_posts.id)
#
module Studio
  class PostGearItem < ApplicationRecord
    belongs_to :post, class_name: "Studio::Post"
    belongs_to :gear_item, class_name: "Studio::GearItem"

    validates :gear_item_id, uniqueness: { scope: :post_id }
  end
end
