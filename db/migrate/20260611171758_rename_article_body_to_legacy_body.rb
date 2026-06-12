# frozen_string_literal: true

# The article body moves to Action Text (action_text_rich_texts). The old
# plain-text column is kept as legacy_body for rollback safety; drop it in a
# follow-up migration once production is verified.
class RenameArticleBodyToLegacyBody < ActiveRecord::Migration[8.1]
  def change
    rename_column :articles, :body, :legacy_body
    change_column_null :articles, :legacy_body, true
  end
end
