# frozen_string_literal: true

class CreateStudioAudioSamples < ActiveRecord::Migration[8.1]
  def change
    create_table :studio_audio_samples do |t|
      t.references :post, null: false, foreign_key: { to_table: :studio_posts }

      t.string  :label, null: false
      t.integer :position, null: false, default: 0

      t.timestamps
    end

    add_index :studio_audio_samples, %i[post_id position]
  end
end
