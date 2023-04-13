require 'rails_helper'

RSpec.describe Customer do
  describe 'relationships' do
    it { should have_many :subscriptions }
    it { should have_many(:teas).through(:subscriptions) }
  end

  describe 'validations' do
    it { should validate_presence_of :first_name }
    it { should validate_presence_of :last_name }
    it { should validate_presence_of :email }
    it { should validate_presence_of :address_line1 }
    it { should validate_presence_of :city }
    it { should validate_presence_of :state }
    it { should validate_presence_of :postal_code }
    it { should validate_presence_of :country }
    it { should validate_uniqueness_of(:email).case_insensitive }
  end
end