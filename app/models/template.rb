class Template < ApplicationRecord
  belongs_to :user

  validates :name, :body, presence: true

  scope :ordered, -> { order(:position, :id) }

  DEFAULTS = [
    { name: "Short", body: "I'm open: {open_dates}. Want me to hold one?", position: 0 },
    { name: "Full List", body: "Available:\n{open_dates_list}\n\nOn hold:\n{hold_dates_list}", position: 1 },
    { name: "By Weekday", body: "{open_dates_grouped}", position: 2 }
  ].freeze
end
