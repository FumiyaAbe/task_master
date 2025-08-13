class Task < ApplicationRecord
  belongs_to :user

  enum :status,   { todo: 0, doing: 1, done: 2 }, prefix: true
  enum :priority, { low: 0,  medium: 1, high: 2 }, prefix: true

  validates :title,    presence: true
  validates :status,   presence: true
  validates :priority, presence: true
end
