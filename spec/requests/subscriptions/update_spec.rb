require 'rails_helper'

RSpec.describe 'patch subscription from active to cancelled' do
  it 'sets active to false for given cusotmers subscription' do
    customer = create(:customer)
    tea = create(:tea)
    subscription = create(:subscription)

    headers = {
      'CONTENT_TYPE' => 'application/json',
      'ACCEPT' => 'application/json'
    }

    patch "/api/v1/subscriptions/#{subscription.id}", headers: headers, params: { customer_id: customer.id }

    sub_data = JSON.parse(response.body, symbolize_names: true)

    expect(response).to have_http_status(200)
    exepect(sub_data).to be_a Hash
    expect(sub_data.keys.sort).to eq(%i[id type attributes].sort)
    expect(sub_data[:id]).to eq(subscription.id)
    expect(sub_data[:type]).to eq('subscription')
    expect(sub_data[:attributes]).to be_a Hash
    expect(sub_data[:attributes].keys.sort).to eq(%i[title price active frequency customer_id tea_id
      created_at updated_at].sort)
      expect(sub_data[:attributes][:title]).to eq(subscription.title)
      expect(sub_data[:attributes][:price]).to eq(subscription.price)
      expect(sub_data[:attributes][:active]).to be(false)
      expect(sub_data[:attributes][:frequency]).to eq(subscription.frequency)
      expect(sub_data[:attributes][:customer_id]).to eq(customer.id)
      expect(sub_data[:attributes][:tea_id]).to eq(tea.id)
      expect(sub_data[:attributes][:created_at]).to eq(subscription.created_at)
      expect(sub_data[:attributes][:updated_at]).to eq(subscription.updated_at)
  end
end