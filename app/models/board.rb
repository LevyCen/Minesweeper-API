class Board < ApplicationRecord
  belongs_to :user
  has_many :square, dependent: :destroy

  validates :name, presence: true
  validates :height, presence: true
  validates :width, presence: true
  validates :enabled, inclusion: {in: [true,false]}
  validates :mines, presence: true
  validates :user_id, presence: true
end
