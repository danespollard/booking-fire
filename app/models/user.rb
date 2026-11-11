class User < ApplicationRecord
  OPENINGS_RANGES = %w[month next_14 next_30 next_60 next_90 custom].freeze
  MAX_OPENINGS_DAYS = 366

  has_secure_password
  has_many :sessions, dependent: :destroy
  has_many :availability_blocks, dependent: :destroy
  has_many :templates, dependent: :destroy

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  before_validation :default_custom_openings_dates
  after_create :create_default_templates

  validates :openings_range, inclusion: { in: OPENINGS_RANGES }
  validate :custom_openings_dates_in_order

  def openings_dates(month:, today: Date.current)
    case openings_range
    when "custom" then openings_from..openings_to
    when /\Anext_(\d+)\z/ then today..(today + ($1.to_i - 1))
    else month.beginning_of_month..month.end_of_month
    end
  end

  private

  def create_default_templates
    templates.create!(Template::DEFAULTS)
  end

  def default_custom_openings_dates
    return unless openings_range == "custom"

    self.openings_from ||= Date.current
    self.openings_to ||= openings_from + 29
  end

  def custom_openings_dates_in_order
    return unless openings_range == "custom" && openings_from && openings_to

    if openings_to < openings_from
      errors.add(:openings_to, "must be on or after the start date")
    elsif (openings_to - openings_from).to_i >= MAX_OPENINGS_DAYS
      errors.add(:openings_to, "must be within a year of the start date")
    end
  end
end
