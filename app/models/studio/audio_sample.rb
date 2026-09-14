# frozen_string_literal: true

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
module Studio
  class AudioSample < ApplicationRecord
    belongs_to :post, class_name: "Studio::Post"

    has_one_attached :file

    validates :label, presence: true
    validate :file_must_be_audio

    scope :ordered, -> { order(:position, :id) }

    private

    def file_must_be_audio
      if !file.attached?
        errors.add(:file, "must be attached")
      elsif !file.content_type.to_s.start_with?("audio/")
        errors.add(:file, "must be an audio file (got #{file.content_type})")
      end
    end
  end
end
