class ChangeFieldsForTalkAssociations < ActiveRecord::Migration[7.0]
  def change
    add_reference :appearances, :talk, foreign_key: true
    add_reference :appearances, :recording, foreign_key: true
    add_reference :recordings, :talk, foreign_key: true
  end
end
