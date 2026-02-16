class AvailabilityBlock < ApplicationRecord
  belongs_to :user

  enum :status, { open: 0, booked: 1 }

  validates :date, presence: true, uniqueness: { scope: :user_id }
  validates :status, presence: true
end
