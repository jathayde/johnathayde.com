# frozen_string_literal: true

class CreateAppearanceTypes < ActiveRecord::Migration[7.0]
  def change
    create_table :appearance_types do |t|
      t.string :title, null: false
      t.string :slug

      t.timestamps
    end
  end
end
