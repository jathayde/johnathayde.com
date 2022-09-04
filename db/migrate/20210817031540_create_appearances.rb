# frozen_string_literal: true

class CreateAppearances < ActiveRecord::Migration[6.1]
  def change
    create_table :appearances do |t|
      t.string :event, null: false
      t.date :date, null: false
      t.string :location, null: false
      t.string :who, null: false
      t.string :what, null: false
      t.text :notes
      t.string :url
      t.string :slug

      t.timestamps
    end
  end
end
