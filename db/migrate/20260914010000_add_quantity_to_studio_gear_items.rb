# frozen_string_literal: true

class AddQuantityToStudioGearItems < ActiveRecord::Migration[8.1]
  def change
    add_column :studio_gear_items, :quantity, :integer, null: false, default: 1
  end
end
