# == Schema Information
#
# Table name: studio_audio_samples
#
#  id         :bigint           not null, primary key
#  label      :string           not null
#  position   :integer          default(0), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  post_id    :bigint           not null
#
# Indexes
#
#  index_studio_audio_samples_on_post_id               (post_id)
#  index_studio_audio_samples_on_post_id_and_position  (post_id,position)
#
# Foreign Keys
#
#  fk_rails_...  (post_id => studio_posts.id)
#
require 'rails_helper'

RSpec.describe Studio::AudioSample, type: :model do
  it "is valid with a label and an audio file" do
    expect(FactoryBot.build(:studio_audio_sample)).to be_valid
  end

  it "requires a file" do
    sample = Studio::AudioSample.new(post: FactoryBot.create(:studio_post), label: "dry")
    expect(sample).not_to be_valid
    expect(sample.errors[:file]).to include("must be attached")
  end

  it "rejects non-audio files" do
    sample = Studio::AudioSample.new(post: FactoryBot.create(:studio_post), label: "dry")
    sample.file.attach(io: Rails.root.join("spec/fixtures/files/feature.png").open,
                       filename: "feature.png", content_type: "image/png")
    expect(sample).not_to be_valid
    expect(sample.errors[:file].first).to include("must be an audio file")
  end
end
