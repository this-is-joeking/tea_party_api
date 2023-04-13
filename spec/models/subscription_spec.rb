require 'rails_helper'

RSpec.describe Subscription do
  describe 'relationships' do
    it { should belong_to :customer }
    it { should belong_to :tea }
  end

  describe 'validations' do
    it { should validate_presence_of :title }
    it { should validate_presence_of :price }
    it { should validate_presence_of :frequency }
    it { should validate_presence_of :customer_id }
    it { should validate_presence_of :tea_id }
  end

  describe '#cancel' do
    it 'updates the subscriptions active from true to false' do
      create(:customer)
      create(:tea)
      subscription = create(:subscription)

      expect(subscription.active).to eq(true)

      subscription.cancel

      expect(subscription.active).to eq(false)
    end
  end
end
