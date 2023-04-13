class Customer < ApplicationRecord
  has_many :subscriptions
  has_many :teas, through: :subscriptions

  validates_presence_of :first_name,
                        :last_name,
                        :email,
                        :address_line1,
                        :city,
                        :state,
                        :postal_code,
                        :country

  validates_uniqueness_of :email, case_sensitive: false

end
