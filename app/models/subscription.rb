class Subscription < ApplicationRecord
  belongs_to :customer
  belongs_to :tea

  validates_presence_of :title,
                        :price,
                        :frequency,
                        :customer_id,
                        :tea_id
  validates_numericality_of :frequency

  enum frequency: { weekly: 0, biweekly: 1, monthly: 2, quarterly: 3 }
  after_initialize :set_active

  private

  def set_active
    self.active ||= true
  end
end
