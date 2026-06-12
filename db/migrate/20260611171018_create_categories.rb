# frozen_string_literal: true

class CreateCategories < ActiveRecord::Migration[8.1]
  def change
    create_table :categories do |t|
      t.string :name, null: false
      t.string :slug
      t.text :description

      t.timestamps
    end
    add_index :categories, :slug, unique: true
    add_index :categories, :name, unique: true
  end
end
