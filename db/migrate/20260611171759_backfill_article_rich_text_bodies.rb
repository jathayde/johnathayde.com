# frozen_string_literal: true

# Converts legacy plain-text article bodies into Action Text rich text.
# simple_format mirrors how the body was rendered before the switch, so the
# output is identical. Idempotent: articles that already have a rich text
# body are skipped.
class BackfillArticleRichTextBodies < ActiveRecord::Migration[8.1]
  def up
    say_with_time "backfilling Action Text bodies for articles" do
      count = 0
      Article.reset_column_information
      Article.find_each do |article|
        next if article.legacy_body.blank?
        next if ActionText::RichText.exists?(record_type: "Article", record_id: article.id, name: "body")

        html = ActionController::Base.helpers.simple_format(article.legacy_body)
        ActionText::RichText.create!(record_type: "Article", record_id: article.id, name: "body", body: html)
        count += 1
      end
      count
    end
  end

  def down
    ActionText::RichText.where(record_type: "Article", name: "body").delete_all
  end
end
