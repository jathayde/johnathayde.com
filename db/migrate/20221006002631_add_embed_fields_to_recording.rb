class AddEmbedFieldsToRecording < ActiveRecord::Migration[7.0]
  def change
    add_column :recordings, :embedded, :boolean, default: false
    add_column :recordings, :embed_host, :string
    add_column :recordings, :embed_code, :text
  end
end
