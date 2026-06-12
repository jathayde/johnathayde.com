# frozen_string_literal: true

class BackfillArticleStatus < ActiveRecord::Migration[8.1]
  def up
    execute <<~SQL
      UPDATE articles SET status = 'published' WHERE published_at IS NOT NULL
    SQL
  end

  def down
    execute <<~SQL
      UPDATE articles SET status = 'draft'
    SQL
  end
end
