class Tea < ApplicationRecord
  has_many :subscriptions
  has_many :customers, through: :subscriptions

  validates_presence_of :title,
                        :description,
                        :brewtime
  
  validates_numericality_of :brewtime
end
