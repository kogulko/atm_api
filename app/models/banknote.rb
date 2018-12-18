class Banknote < ApplicationRecord
  AVAILABLE_FACE_VALUES = [1, 2, 5, 10, 25, 50].freeze

  enum face_value: Hash[AVAILABLE_FACE_VALUES.collect { |item| [item.to_s, item] } ]

  default_scope { order(face_value: :desc) }
  scope :in_stock, lambda { |face_value = AVAILABLE_FACE_VALUES.max| where('quantity > 0 AND face_value <= ?', face_value) }


  validates :face_value, uniqueness: true
  validates :quantity, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  def self.total_sum
    sum('face_value * quantity')
  end
end
