# frozen_string_literal: true

class CreateStudioPostGearItems < ActiveRecord::Migration[8.1]
  def change
    create_table :studio_post_gear_items do |t|
      t.references :post,      null: false, foreign_key: { to_table: :studio_posts }
      t.references :gear_item, null: false, foreign_key: { to_table: :studio_gear_items }

      t.timestamps
    end

    add_index :studio_post_gear_items, %i[post_id gear_item_id], unique: true
  end
end
