class AddSpeakerDeckEmbedToTalks < ActiveRecord::Migration[7.0]
  def change
    add_column :talks, :speaker_deck_embed, :string
    add_column :appearances, :speaker_deck_override, :string
  end
end
