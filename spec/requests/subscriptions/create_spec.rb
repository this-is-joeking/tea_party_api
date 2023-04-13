require 'rails_helper'

RSpec.describe 'post a new subscription for given customer' do
  it 'creates a new subscription for the given customer' do
    cust = create(:customer)
    tea = create(:tea)

    headers = {
      'CONTENT_TYPE' => 'application/json',
      'ACCEPT' => 'application/json'
    }
    body = {
      title: 'Test Tea Subscription',
      price: 5.99,
      frequency: 1,
      customer_id: cust.id,
      tea_id: tea.id
    }
    post '/api/v1/subscriptions', headers: headers, params: body.to_json

    success_message = JSON.parse(response.body, symbolize_names: true)

    expect(response).to have_http_status(201)
    expect(success_message).to be_a Hash
    expect(success_message).to eq({ success: 'Subscription added successfully' })
    expect(cust.teas).to eq([tea])

    sub = cust.subscriptions.last
    
    expect(sub.title).to eq('Test Tea Subscription')
    expect(sub.price).to eq(5.99)
    expect(sub.frequency).to eq('biweekly')
    expect(sub.tea_id).to eq(tea.id)
  end
end