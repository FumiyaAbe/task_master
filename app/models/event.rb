class Event < ApplicationRecord
  belongs_to :user

  # 必須
  validates :title,     presence: true, length: { maximum: 100 }
  validates :starts_at, presence: true
  validates :ends_at,   presence: true

  # 任意（空は許可）＋上限
  validates :location, length: { maximum: 100 }, allow_blank: true
  validates :notes,    length: { maximum: 2000 }, allow_blank: true

  # 期間の整合性
  validate :ends_after_starts, if: -> { starts_at.present? && ends_at.present? }

  private

  def ends_after_starts
    errors.add(:ends_at, "は開始日時以降にしてください") if ends_at < starts_at
  end
end
