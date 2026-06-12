# frozen_string_literal: true

class AddCanonicalUrlToArticles < ActiveRecord::Migration[8.1]
  def change
    add_column :articles, :canonical_url, :string
  end
end
