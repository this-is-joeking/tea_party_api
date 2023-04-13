class SubscriptionSerializer
  include JSONAPI::Serializer
  attributes :title, :price, :active, :frequency, :customer_id, :tea_id, :created_at, :updated_at
end
