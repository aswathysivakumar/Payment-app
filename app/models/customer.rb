# Customer Related Info
class Customer < ApplicationRecord
  has_many :payments
  has_many :recipients
end
