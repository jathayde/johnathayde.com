class Appearance < ApplicationRecord
  extend FriendlyId
  friendly_id :slug, use: [:slugged, :finders]

  validates :event,     presence: true
  validates :date,      presence: true
  validates :location,  presence: true
  validates :who,       presence: true
  validates :what,      presence: true

  before_validation :set_slug

  # Use lambda because it only runs app on boot, Date.today needs to be calculated whenever the scope is called instead. ALso, with {} keep on one line (ruby writing style)
  scope :upcoming, lambda { where("appearances.date >= ?", Date.today) }
  scope :past, lambda { where("appearances.date < ?", Date.today) }

  def year
    date.strftime("%Y")
  end

  def month
    date.strftime("%m")
  end

  private

  def set_slug
    self.slug = "#{event}".parameterize
  end
end
