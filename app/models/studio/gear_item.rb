# frozen_string_literal: true

# == Schema Information
#
# Table name: studio_gear_items
#
#  id            :bigint           not null, primary key
#  active        :boolean          default(TRUE), not null
#  affiliate_url :string
#  blurb         :text
#  category      :string           default("misc"), not null
#  manufacturer  :string
#  name          :string           not null
#  position      :integer          default(0), not null
#  quantity      :integer          default(1), not null
#  slug          :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_studio_gear_items_on_active                 (active)
#  index_studio_gear_items_on_category_and_position  (category,position)
#  index_studio_gear_items_on_slug                   (slug) UNIQUE
#
module Studio
  class GearItem < ApplicationRecord
    extend FriendlyId
    friendly_id :slug_candidates, use: %i[slugged]

    # Signal-chain order: source to output, then the rest.
    enum :category, {
      mics: "mics",
      preamps: "preamps",
      compressors: "compressors",
      converters: "converters",
      monitoring: "monitoring",
      outboard: "outboard",
      instruments: "instruments",
      synths: "synths",
      samplers: "samplers",
      midi: "midi",
      amplifiers: "amplifiers",
      software: "software",
      video: "video",
      misc: "misc"
    }, default: :misc

    CATEGORY_LABELS = {
      "mics" => "Microphones",
      "preamps" => "Preamps",
      "compressors" => "Compressors",
      "converters" => "Converters and Interfaces",
      "monitoring" => "Monitoring",
      "outboard" => "Outboard",
      "instruments" => "Instruments",
      "synths" => "Synths / Keyboards",
      "samplers" => "Samplers",
      "midi" => "MIDI",
      "amplifiers" => "Amplifiers",
      "software" => "Software",
      "video" => "Video",
      "misc" => "Miscellaneous"
    }.freeze

    has_many :post_gear_items, class_name: "Studio::PostGearItem", dependent: :destroy
    has_many :posts, through: :post_gear_items, class_name: "Studio::Post"

    validates :name, presence: true
    validates :quantity, numericality: { only_integer: true, greater_than_or_equal_to: 1 }
    validates :affiliate_url, format: { with: %r{\Ahttps?://\S+\z}i, message: "must be an http(s) URL" },
                              allow_blank: true

    scope :active,  -> { where(active: true) }
    scope :ordered, -> { order(:position, :name) }

    # Active items grouped by category, in signal-chain order, with empty
    # categories dropped. Runs one query.
    def self.grouped_for_display
      grouped = active.ordered.group_by(&:category)
      categories.keys.filter_map { |key| [key, grouped[key]] if grouped[key] }
    end

    def category_label
      CATEGORY_LABELS.fetch(category, category.to_s.humanize)
    end

    def display_name
      [manufacturer, name].compact_blank.join(" ")
    end

    # "2x" prefix when there is more than one, otherwise nothing.
    def quantity_label
      "#{quantity}\u00d7" if quantity.to_i > 1
    end

    def affiliate?
      affiliate_url.present?
    end

    def slug_candidates
      [%i[manufacturer name], :name]
    end

    def should_generate_new_friendly_id?
      slug.blank? || name_changed? || manufacturer_changed?
    end
  end
end
