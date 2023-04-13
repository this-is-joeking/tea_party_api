module Api
  module V1
    class SubscriptionsController < ApplicationController
      before_action :find_customer, only: :index

      def index
        render json: SubscriptionSerializer.new(@customer.subscriptions), status: :ok
      end

      private

      def find_customer
        @customer = Customer.find_by(id: params[:customer_id])
        validate_customer
      end

      def validate_customer
        return if @customer

        if params[:customer_id]
          render json: ErrorSerializer.invalid_id("customer"), status: :bad_request
        else
          render json: ErrorSerializer.missing_parameter('customer_id'), status: :bad_request
        end
      end
    end
  end
end