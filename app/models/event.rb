class Event < ApplicationRecord
  belongs_to :user

  validates :title,     presence: true
  validates :starts_at, presence: true

  validate :ends_after_starts, if: -> { starts_at.present? && ends_at.present? }

  private

  def ends_after_starts
    errors.add(:ends_at, "は開始日時以降にしてください") if ends_at < starts_at
  end
end
