class Banknote < ApplicationRecord
  AVAILABLE_FACE_VALUES = [1, 2, 5, 10, 25, 50].freeze

  enum face_value: Hash[AVAILABLE_FACE_VALUES.collect { |item| [item.to_s, item] } ]

  validates :face_value, uniqueness: true
  validates :quantity, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  def self.total_sum
    sum('face_value * quantity')
  end
end
