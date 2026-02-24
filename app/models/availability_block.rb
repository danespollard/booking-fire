class AvailabilityBlock < ApplicationRecord
  belongs_to :user

  enum :status, { open: 0, booked: 1, hold: 2 }
  enum :time_label, { anytime: 0, daytime: 1, evening: 2, after_9pm: 3 }, prefix: true

  validates :date, presence: true, uniqueness: { scope: :user_id }
  validates :status, presence: true

  def display_time_label
    return nil if time_label_anytime?

    time_label.humanize
  end
end
