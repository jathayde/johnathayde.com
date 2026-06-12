# frozen_string_literal: true

class AddCategoryToArticles < ActiveRecord::Migration[8.1]
  def change
    add_reference :articles, :category, null: true, foreign_key: true
  end
end
