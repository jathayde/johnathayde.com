# frozen_string_literal: true

class CreateStudioGearItems < ActiveRecord::Migration[8.1]
  def change
    create_table :studio_gear_items do |t|
      t.string  :name, null: false
      t.string  :manufacturer
      t.string  :slug
      t.string  :category, null: false, default: "misc" # signal-chain group
      t.text    :blurb
      t.string  :affiliate_url
      t.integer :position, null: false, default: 0
      t.boolean :active, null: false, default: true

      t.timestamps
    end

    add_index :studio_gear_items, :slug, unique: true
    add_index :studio_gear_items, %i[category position]
    add_index :studio_gear_items, :active
  end
end
