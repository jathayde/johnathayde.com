class AddAppearanceTypeReferenceToAppearance < ActiveRecord::Migration[7.0]
  def change
    add_reference :appearances, :appearance_type, null: false, foreign_key: true
  end
end
