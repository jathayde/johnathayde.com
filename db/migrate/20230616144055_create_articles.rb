class CreateArticles < ActiveRecord::Migration[7.0]
  def change
    create_table :articles do |t|
      t.string :title, null: false
      t.string :subtitle
      t.string :author
      t.text :body, null: false
      t.datetime :published_at
      t.string :slug
      t.text :page_title, limit: 70, null: false
      t.string :meta_description, limit: 155, null: false
      t.string :img_source
      t.string :og_title
      t.string :og_description
      t.string :og_image
      t.string :twitter_title
      t.string :twitter_description
      t.string :twitter_image
      t.boolean :hidden_on_index, default: false
      
      t.timestamps
    end
  end
end
