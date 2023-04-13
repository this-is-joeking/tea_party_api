require 'rails_helper'

RSpec.describe 'patch subscription from active to cancelled' do
  it 'sets active to false for given cusotmers subscription' do
    customer = create(:customer)
    tea = create(:tea)
    subscription = create(:subscription)

    expect(Subscription.last.active).to eq(true)

    headers = {
      'CONTENT_TYPE' => 'application/json',
      'ACCEPT' => 'application/json'
    }

    patch "/api/v1/subscriptions/#{subscription.id}", headers: headers, params: { customer_id: customer.id }.to_json

    sub_data = JSON.parse(response.body, symbolize_names: true)

    expect(response).to have_http_status(200)
    expect(sub_data).to be_a Hash
    expect(sub_data.keys).to eq([:data])
    expect(sub_data[:data].keys.sort).to eq(%i[id type attributes].sort)
    expect(sub_data[:data][:id].to_i).to eq(subscription.id)
    expect(sub_data[:data][:type]).to eq('subscription')
    expect(sub_data[:data][:attributes]).to be_a Hash
    expect(sub_data[:data][:attributes].keys.sort).to eq(%i[title price active frequency customer_id tea_id
                                                            created_at updated_at].sort)
    expect(sub_data[:data][:attributes][:title]).to eq(subscription.title)
    expect(sub_data[:data][:attributes][:price]).to eq(subscription.price)
    expect(sub_data[:data][:attributes][:active]).to be(false)
    expect(sub_data[:data][:attributes][:frequency]).to eq(subscription.frequency)
    expect(sub_data[:data][:attributes][:customer_id]).to eq(customer.id)
    expect(sub_data[:data][:attributes][:tea_id]).to eq(tea.id)
    expect(sub_data[:data][:attributes][:created_at].to_datetime.beginning_of_minute).to eq(subscription.created_at.to_datetime.beginning_of_minute)
    expect(sub_data[:data][:attributes][:updated_at].to_datetime.beginning_of_minute).to eq(subscription.updated_at.beginning_of_minute)
    expect(Subscription.last.active).to eq(false)
  end

  describe 'edge cases' do
    it 'returns a helpful error message if you try to cancel a subscription that is already cancelled' do
      customer = create(:customer)
      tea = create(:tea)
      subscription = create(:subscription)
      subscription.cancel
      expect(Subscription.last.active).to eq(false)

      headers = {
        'CONTENT_TYPE' => 'application/json',
        'ACCEPT' => 'application/json'
      }

      patch "/api/v1/subscriptions/#{subscription.id}", headers: headers, params: { customer_id: customer.id }.to_json

      error_message = JSON.parse(response.body, symbolize_names: true)

      expect(response).to have_http_status(400)
      expect(error_message).to be_a Hash
      expect(error_message.keys).to eq([:error])
      expect(error_message[:error].keys.sort).to eq(%i[code message].sort)
      expect(error_message[:error][:code]).to eq(400)
      expect(error_message[:error][:message]).to eq('Invalid request, subscription is already cancelled')
    end
  end

  describe 'sad paths' do
    it 'returns an error message if subscription id passed is invalid' do
      customer = create(:customer)
      tea = create(:tea)
      sub_id = Subscription.maximum(:id).to_i + 1

      headers = {
        'CONTENT_TYPE' => 'application/json',
        'ACCEPT' => 'application/json'
      }

      patch "/api/v1/subscriptions/#{sub_id}", headers: headers, params: { customer_id: customer.id }.to_json

      error_message = JSON.parse(response.body, symbolize_names: true)

      expect(response).to have_http_status(400)
      expect(error_message).to be_a Hash
      expect(error_message.keys).to eq([:error])
      expect(error_message[:error].keys.sort).to eq(%i[code message].sort)
      expect(error_message[:error][:code]).to eq(400)
      expect(error_message[:error][:message]).to eq("Couldn't find Subscription with 'id'=#{sub_id}")
    end

    it 'returns an error message if customer does not own the subscription' do
      customer1 = create(:customer)
      customer2 = create(:customer)
      tea = create(:tea)
      sub_id = create(:subscription, customer_id: customer2.id).id

      headers = {
        'CONTENT_TYPE' => 'application/json',
        'ACCEPT' => 'application/json'
      }

      patch "/api/v1/subscriptions/#{sub_id}", headers: headers, params: { customer_id: customer1.id }.to_json

      error_message = JSON.parse(response.body, symbolize_names: true)

      expect(response).to have_http_status(400)
      expect(error_message).to be_a Hash
      expect(error_message.keys).to eq([:error])
      expect(error_message[:error].keys.sort).to eq(%i[code message].sort)
      expect(error_message[:error][:code]).to eq(400)
      expect(error_message[:error][:message]).to eq('Invalid request, subscription does not belong to customer_id')
    end

    it 'returns an error if customer id is missing' do
      customer = create(:customer)
      tea = create(:tea)
      subscription = create(:subscription)

      expect(Subscription.last.active).to eq(true)

      headers = {
        'CONTENT_TYPE' => 'application/json',
        'ACCEPT' => 'application/json'
      }

      patch "/api/v1/subscriptions/#{subscription.id}", headers: headers

      error_message = JSON.parse(response.body, symbolize_names: true)

      expect(response).to have_http_status(400)
      expect(error_message).to be_a Hash
      expect(error_message.keys).to eq([:error])
      expect(error_message[:error].keys.sort).to eq(%i[code message].sort)
      expect(error_message[:error][:code]).to eq(400)
      expect(error_message[:error][:message]).to eq('Invalid request, customer_id is a required parameter')
    end

    it 'returns an error if customer id is invalid' do
      customer_id = create(:customer).id + 1
      tea = create(:tea)
      subscription = create(:subscription)

      expect(Subscription.last.active).to eq(true)

      headers = {
        'CONTENT_TYPE' => 'application/json',
        'ACCEPT' => 'application/json'
      }

      patch "/api/v1/subscriptions/#{subscription.id}", headers: headers, params: { customer_id: customer_id }.to_json

      error_message = JSON.parse(response.body, symbolize_names: true)

      expect(response).to have_http_status(400)
      expect(error_message).to be_a Hash
      expect(error_message.keys).to eq([:error])
      expect(error_message[:error].keys.sort).to eq(%i[code message].sort)
      expect(error_message[:error][:code]).to eq(400)
      expect(error_message[:error][:message]).to eq('Invalid request, customer_id is invalid')
    end
  end
end
