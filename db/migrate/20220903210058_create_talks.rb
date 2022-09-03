class CreateTalks < ActiveRecord::Migration[7.0]
  def change
    create_table :talks do |t|
      t.string :title, null: false
      t.text :description, null: false
      t.string :slug

      t.timestamps
    end
  end
end
