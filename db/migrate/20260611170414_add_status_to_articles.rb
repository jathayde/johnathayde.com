# frozen_string_literal: true

class AddStatusToArticles < ActiveRecord::Migration[8.1]
  def change
    add_column :articles, :status, :string, null: false, default: "draft"
    add_index :articles, :status
  end
end
