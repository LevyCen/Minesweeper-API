class Square < ApplicationRecord
  belongs_to :board

  validates :row, presence: true
  validates :column, presence: true
  validates :value, presence: true
  validates :mine, inclusion: {in: [true,false]}
  validates :open, inclusion: {in: [true,false]}
  validates :board_id, presence: true
end
