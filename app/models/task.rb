class Task < ApplicationRecord
  belongs_to :user

  # 整数 enum（正しいオプションは default: ）
  enum :status,   { todo: 0, doing: 1, done: 2 },   prefix: true, default: :todo
  enum :priority, { low: 0,  medium: 1, high: 2 },  prefix: true, default: :medium

  # バリデーション
  validates :title, presence: true, length: { maximum: 100 }
  validates :body,  length: { maximum: 2000 }, allow_blank: true
  validates :status,   inclusion: { in: statuses.keys }
  validates :priority, inclusion: { in: priorities.keys }

  # 期限に制約を付けたい場合の例
  # validate :due_at_not_in_past
  # private
  # def due_at_not_in_past
  #   return if due_at.blank?
  #   errors.add(:due_at, "は現在より後の日時にしてください") if due_at < Time.current
  # end
end
