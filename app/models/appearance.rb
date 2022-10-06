# frozen_string_literal: true

# == Schema Information
#
# Table name: appearances
#
#  id                    :bigint           not null, primary key
#  date                  :date             not null
#  event                 :string           not null
#  location              :string           not null
#  notes                 :text
#  slug                  :string
#  speaker_deck_override :string
#  url                   :string
#  what                  :string           not null
#  who                   :string           not null
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  appearance_type_id    :bigint           not null
#  recording_id          :bigint
#  talk_id               :bigint
#
# Indexes
#
#  index_appearances_on_appearance_type_id  (appearance_type_id)
#  index_appearances_on_recording_id        (recording_id)
#  index_appearances_on_talk_id             (talk_id)
#
# Foreign Keys
#
#  fk_rails_...  (appearance_type_id => appearance_types.id)
#  fk_rails_...  (recording_id => recordings.id)
#  fk_rails_...  (talk_id => talks.id)
#
class Appearance < ApplicationRecord
  extend FriendlyId
  friendly_id :slug, use: %i[slugged finders]

  belongs_to :appearance_type
  belongs_to :talk, optional: true

  has_many :recordings, dependent: :destroy
  accepts_nested_attributes_for :recordings, allow_destroy: true

  before_validation :set_slug

  validates :event,     presence: true
  validates :date,      presence: true
  validates :location,  presence: true
  validates :who,       presence: true
  validates :what,      presence: true

  # Use lambda because it only runs app on boot, Time.zone.today needs to be
  # calculated whenever the scope is called instead. Also, with {} keep
  # on one line (ruby writing style)
  scope :upcoming, -> { where('appearances.date >= ?', Time.zone.today) }
  scope :past, -> { where('appearances.date < ?', Time.zone.today) }

  def year
    date.strftime('%Y')
  end

  def month
    date.strftime('%m')
  end

  private

  def set_slug
    self.slug = event.to_s.parameterize
  end
end
