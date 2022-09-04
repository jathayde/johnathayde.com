# frozen_string_literal: true

class CreateRecordings < ActiveRecord::Migration[6.1]
  def change
    create_table :recordings do |t|
      t.string :title, null: false
      t.string :url, null: false
      t.string :slug
      t.date :recorded_on
      t.text :notes

      t.timestamps
    end
  end
end
