class Task < ApplicationRecord
  validates :name,   presence: true, length: {maximum: 100}
  validates :detail, length: {maximum: 1000}
end
