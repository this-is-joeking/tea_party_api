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

  describe 'sad paths' do
    it 'returns an error message if passed an invalid customer id' do
      tea = create(:tea)

      headers = {
        'CONTENT_TYPE' => 'application/json',
        'ACCEPT' => 'application/json'
      }
      body = {
        title: 'Test Tea Subscription',
        price: 5.99,
        frequency: 1,
        customer_id: 1,
        tea_id: tea.id
      }
      post '/api/v1/subscriptions', headers: headers, params: body.to_json

      error_message = JSON.parse(response.body, symbolize_names: true)

      expect(response).to_not be_successful
      expect(response).to have_http_status(400)
      expect(error_message).to be_a Hash
      expect(error_message.keys).to eq([:error])
      expect(error_message[:error].keys.sort).to eq(%i[code message].sort)
      expect(error_message[:error][:code]).to eq(400)
      expect(error_message[:error][:message]).to eq('Invalid request, customer_id is invalid')
    end

    it 'returns an error message if passed an invalid tea id' do
      cust = create(:customer)
  
      headers = {
        'CONTENT_TYPE' => 'application/json',
        'ACCEPT' => 'application/json'
      }
      body = {
        title: 'Test Tea Subscription',
        price: 5.99,
        frequency: 1,
        customer_id: cust.id,
        tea_id: 1
      }
      post '/api/v1/subscriptions', headers: headers, params: body.to_json
      
      error_message = JSON.parse(response.body, symbolize_names: true)

      expect(response).to_not be_successful
      expect(response).to have_http_status(400)
      expect(error_message).to be_a Hash
      expect(error_message.keys).to eq([:error])
      expect(error_message[:error].keys.sort).to eq(%i[code message].sort)
      expect(error_message[:error][:code]).to eq(400)
      expect(error_message[:error][:message]).to eq('Validation failed: Tea must exist')
    end

    it 'returns an error message if customer id is not passed' do
      tea = create(:tea)
  
      headers = {
        'CONTENT_TYPE' => 'application/json',
        'ACCEPT' => 'application/json'
      }
      body = {
        title: 'Test Tea Subscription',
        price: 5.99,
        frequency: 1,
        tea_id: tea.id
      }
      post '/api/v1/subscriptions', headers: headers, params: body.to_json
      
      error_message = JSON.parse(response.body, symbolize_names: true)

      expect(response).to_not be_successful
      expect(response).to have_http_status(400)
      expect(error_message).to be_a Hash
      expect(error_message.keys).to eq([:error])
      expect(error_message[:error].keys.sort).to eq(%i[code message].sort)
      expect(error_message[:error][:code]).to eq(400)
      expect(error_message[:error][:message]).to eq('Invalid request, customer_id is a required parameter')
    end

    it 'returns an error message tea id is not passed' do
      cust = create(:customer)
  
      headers = {
        'CONTENT_TYPE' => 'application/json',
        'ACCEPT' => 'application/json'
      }
      body = {
        title: 'Test Tea Subscription',
        price: 5.99,
        frequency: 1,
        customer_id: cust.id
      }
      post '/api/v1/subscriptions', headers: headers, params: body.to_json
      
      error_message = JSON.parse(response.body, symbolize_names: true)

      expect(response).to_not be_successful
      expect(response).to have_http_status(400)
      expect(error_message).to be_a Hash
      expect(error_message.keys).to eq([:error])
      expect(error_message[:error].keys.sort).to eq(%i[code message].sort)
      expect(error_message[:error][:code]).to eq(400)
      expect(error_message[:error][:message]).to eq("Validation failed: Tea must exist, Tea can't be blank")
    end

    it 'returns a validation error if missing other required params' do
      cust = create(:customer)
      tea = create(:tea)
  
      headers = {
        'CONTENT_TYPE' => 'application/json',
        'ACCEPT' => 'application/json'
      }
      body = {
        customer_id: cust.id,
        tea_id: tea.id
      }
      post '/api/v1/subscriptions', headers: headers, params: body.to_json
  
      error_message = JSON.parse(response.body, symbolize_names: true)

      expect(response).to_not be_successful
      expect(response).to have_http_status(400)
      expect(error_message).to be_a Hash
      expect(error_message.keys).to eq([:error])
      expect(error_message[:error].keys.sort).to eq(%i[code message].sort)
      expect(error_message[:error][:code]).to eq(400)
      expect(error_message[:error][:message]).to eq("Validation failed: Title can't be blank, Price can't be blank, Frequency can't be blank, Frequency is not a number")
    end
  end
end