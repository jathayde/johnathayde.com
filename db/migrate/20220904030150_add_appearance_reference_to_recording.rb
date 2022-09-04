class AddAppearanceReferenceToRecording < ActiveRecord::Migration[7.0]
  def change
    add_reference :recordings, :appearance, null: false, foreign_key: true
  end
end
