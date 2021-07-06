class User < ApplicationRecord
    has_many :board

    validates :email, presence: true
    validates :name, presence: true
    validates :auth_token, presence: true
end
