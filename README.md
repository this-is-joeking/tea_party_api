![Github CI](https://github.com/this-is-joeking/tea_party_api/actions/workflows/rubyonrails.yml/badge.svg)
[![codecov](https://codecov.io/github/this-is-joeking/tea_party_api/branch/main/graph/badge.svg?token=FWFJ8JRP6Z)](https://app.codecov.io/gh/this-is-joeking/tea_party_api)
[![Ruby Style Guide](https://img.shields.io/badge/code_style-rubocop-brightgreen.svg)](https://github.com/rubocop/rubocop)
# Tea Party API

This REST API is a partial design of a back end for a tea subscription service. It offers clients the ability to send request to [get all subscriptions](#get-all-subscriptions-for-a-given-customer) for a customer, [create a new customer subscription](#create-a-new-subscription-for-a-given-customer), or [deactivate a customer subscription](#deactivate-a-customer-subscription).

## Built with
```
Rails 5.2.8.1
Ruby 2.7.4
RSpec 3.1.2
PostgreSQL
```

## Setup

1. Fork and clone this repository
1. `cd` into the root directory
1. Run `bundle install`
1. Run `rails db:{drop,create,migrate}` to setup the databases
1. Run `bundle exec rspec` to run the test suite
1. Run `rails server` to start the rails server at `http://localhost:3000`
  - Example of requests you can send are available below
  
## API Endpoints

### Get all subscriptions for a given customer
  __Request__
  
  `get '/api/v1/subscriptions'`

  Body

  ```
  { "customer_id" = "1" }
  ```
    
  __Response__
  
  ```
  {
  "data": [
      {
          "id": "1",
          "type": "subscription",
          "attributes": {
              "title": "Hibiscus",
              "price": 6.81,
              "active": false,
              "frequency": "quarterly",
              "customer_id": 1,
              "tea_id": 9,
              "created_at": "2023-04-13T00:49:06.976Z",
              "updated_at": "2023-04-13T00:49:06.976Z"
          }
      },
      {
          "id": "10",
          "type": "subscription",
          "attributes": {
              "title": "Che Dang",
              "price": 58.74,
              "active": true,
              "frequency": "monthly",
              "customer_id": 1,
              "tea_id": 3,
              "created_at": "2023-04-13T00:49:07.019Z",
              "updated_at": "2023-04-13T00:49:07.019Z"
          }
      },
      {
          "id": "19",
          "type": "subscription",
          "attributes": {
              "title": "Shui Xian",
              "price": 17.71,
              "active": true,
              "frequency": "quarterly",
              "customer_id": 1,
              "tea_id": 10,
              "created_at": "2023-04-13T00:49:07.055Z",
              "updated_at": "2023-04-13T00:49:07.055Z"
            }
        }
      ]
    }
  ```
---
### Create a new subscription for a given customer 
  __Request__
  
  `post '/api/v1/subscriptions'`
  
  Body
  
  ```
  {
      "title": 'Test Tea Subscription',
      "price": 5.99,
      "frequency": 1,
      "customer_id": 5,
      "tea_id": 10
    }
  ```
  
  __Response__
  
  ```
  {
    "success": "Subscription added successfully"
  }
  ```
  ---
### Deactivate a customer subscription
  __Request__
  
  `patch '/api/v1/subscriptions/<subscription_id>'`
  
  Body
  
  ```
  { "customer_id" : "1" }
  ```
  
  __Response__
  
  ```
  {
    "data": {
        "id": "4",
        "type": "subscription",
        "attributes": {
            "title": "Darjeeling",
            "price": 20.65,
            "active": false,
            "frequency": "quarterly",
            "customer_id": 1,
            "tea_id": 6,
            "created_at": "2023-04-13T19:21:00.526Z",
            "updated_at": "2023-04-13T21:07:12.001Z"
            }
        }
   }
  ```
  
## Database Diagram
![Database schema](/docs/db_diagram.png)
