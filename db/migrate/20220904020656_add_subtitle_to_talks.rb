# frozen_string_literal: true

class AddSubtitleToTalks < ActiveRecord::Migration[7.0]
  def change
    add_column :talks, :subtitle, :string
  end
end
