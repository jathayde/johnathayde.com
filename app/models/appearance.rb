# frozen_string_literal: true

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
