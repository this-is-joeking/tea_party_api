require 'rails_helper'

RSpec.describe 'get a customers subscriptions' do
  it 'returns all subscriptions for given customer' do
    customer = create(:customer)
    create_list(:tea, 10)
    create_list(:subscription, 10)

    headers = {
      'CONTENT_TYPE' => 'application/json',
      'ACCEPT' => 'application/json'
    }
    get '/api/v1/subscriptions', headers: headers, params: { customer_id: customer.id }

    subscriptions_data = JSON.parse(response.body, symbolize_names: true)  
  
    expect(response).to be_successful
    expect(response).to have_http_status(200)
    expect(subscriptions_data).to be_a Hash
    expect(subscriptions_data.keys).to eq([:data])
    expect(subscriptions_data[:data]).to be_a Array
    expect(subscriptions_data[:data].length).to eq(10)
    subscriptions_data[:data].each do |sub_data|
      expect(sub_data).to be_a Hash
      expect(sub_data.keys.sort).to eq([:id, :type, :attributes].sort)
      expect(sub_data[:id]).to be_a String
      expect(Subscription.exists?(sub_data[:id]))
      expect(sub_data[:type]).to eq('subscription')
      expect(sub_data[:attributes]).to be_a Hash
      expect(sub_data[:attributes].keys.sort).to eq([:title, :price, :active, :frequency, :customer_id, :tea_id, :created_at, :updated_at].sort)
      expect(sub_data[:attributes][:title]).to be_a String
      expect(sub_data[:attributes][:price]).to be_a Float
      expect(sub_data[:attributes][:active]).to eq(true)
      expect(sub_data[:attributes][:frequency]).to be_a String
      expect(sub_data[:attributes][:customer_id]).to eq(customer.id)
      expect(sub_data[:attributes][:tea_id]).to be_a Integer
      expect(Tea.exists?(sub_data[:attributes][:tea_id]))
      expect(sub_data[:attributes][:created_at].to_datetime).to be_a DateTime
      expect(sub_data[:attributes][:updated_at].to_datetime).to be_a DateTime
    end
  end
  
  it 'returns both cancelled and active subscriptions' do
    customer = create(:customer)
    create_list(:tea, 10)
    create_list(:subscription, 5)
    5.times do
      create(:subscription, active: false)
    end

    headers = {
      'CONTENT_TYPE' => 'application/json',
      'ACCEPT' => 'application/json'
    }
    get '/api/v1/subscriptions', headers: headers, params: { customer_id: customer.id }

    subscriptions_data = JSON.parse(response.body, symbolize_names: true)  
  
    expect(response).to be_successful
    expect(response).to have_http_status(200)
    expect(subscriptions_data).to be_a Hash
    expect(subscriptions_data.keys).to eq([:data])
    expect(subscriptions_data[:data]).to be_a Array
    expect(subscriptions_data[:data].length).to eq(10)
    subscriptions_data[:data].each do |sub_data|
      expect(sub_data).to be_a Hash
      expect(sub_data.keys.sort).to eq([:id, :type, :attributes].sort)
      expect(sub_data[:id]).to be_a String
      expect(Subscription.exists?(sub_data[:id]))
      expect(sub_data[:type]).to eq('subscription')
      expect(sub_data[:attributes]).to be_a Hash
      expect(sub_data[:attributes].keys.sort).to eq([:title, :price, :active, :frequency, :customer_id, :tea_id, :created_at, :updated_at].sort)
      expect(sub_data[:attributes][:title]).to be_a String
      expect(sub_data[:attributes][:price]).to be_a Float
      expect(sub_data[:attributes][:active]).to be_in([true, false])
      expect(sub_data[:attributes][:frequency]).to be_a String
      expect(sub_data[:attributes][:customer_id]).to eq(customer.id)
      expect(sub_data[:attributes][:tea_id]).to be_a Integer
      expect(Tea.exists?(sub_data[:attributes][:tea_id]))
      expect(sub_data[:attributes][:created_at].to_datetime).to be_a DateTime
      expect(sub_data[:attributes][:updated_at].to_datetime).to be_a DateTime
    end
  end

  it 'returns an empty array if there are no subscriptions for given customer' do
    customer = create(:customer)

    headers = {
      'CONTENT_TYPE' => 'application/json',
      'ACCEPT' => 'application/json'
    }
    get '/api/v1/subscriptions', headers: headers, params: { customer_id: customer.id }

    subscriptions_data = JSON.parse(response.body, symbolize_names: true)  
  
    expect(response).to be_successful
    expect(response).to have_http_status(200)
    expect(subscriptions_data).to be_a Hash
    expect(subscriptions_data.keys).to eq([:data])
    expect(subscriptions_data[:data]).to eq([])
  end

  describe 'sad paths' do
    it 'returns an error if customer id parameter is not sent' do
      customer = create(:customer)
      create_list(:tea, 10)
      create_list(:subscription, 5)
      5.times do
        create(:subscription, active: false)
      end
  
      headers = {
        'CONTENT_TYPE' => 'application/json',
        'ACCEPT' => 'application/json'
      }
      get '/api/v1/subscriptions', headers: headers
  
      error_message = JSON.parse(response.body, symbolize_names: true)

      expect(response).to_not be_successful
      expect(response).to have_http_status(400)
      expect(error_message).to be_a Hash
      expect(error_message.keys).to eq([:error])
      expect(error_message[:error].keys.sort).to eq(%i[code message].sort)
      expect(error_message[:error][:code]).to eq(400)
      expect(error_message[:error][:message]).to eq('Invalid request, customer_id is a required parameter')
    end

    it 'returns an error if customer id is invalid' do
      headers = {
        'CONTENT_TYPE' => 'application/json',
        'ACCEPT' => 'application/json'
      }
      get '/api/v1/subscriptions', headers: headers, params: { customer_id: 1 }

      error_message = JSON.parse(response.body, symbolize_names: true)

      expect(response).to_not be_successful
      expect(response).to have_http_status(400)
      expect(error_message).to be_a Hash
      expect(error_message.keys).to eq([:error])
      expect(error_message[:error].keys.sort).to eq(%i[code message].sort)
      expect(error_message[:error][:code]).to eq(400)
      expect(error_message[:error][:message]).to eq('Invalid request, customer_id is invalid')
    end
  end
end