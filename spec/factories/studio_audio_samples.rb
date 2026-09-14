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
FactoryBot.define do
  factory :studio_audio_sample, class: "Studio::AudioSample" do
    association :post, factory: :studio_post
    sequence(:label) { |n| "Sample #{n}" }
    sequence(:position)

    after(:build) do |sample|
      next if sample.file.attached?

      sample.file.attach(
        io: Rails.root.join("spec/fixtures/files/sample.wav").open,
        filename: "sample.wav",
        content_type: "audio/wav"
      )
    end
  end
end
