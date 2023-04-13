module Api
  module V1
    class SubscriptionsController < ApplicationController
      rescue_from ActiveRecord::RecordInvalid, with: :render_error
      before_action :find_customer, only: [:index, :create]

      def index
        render json: SubscriptionSerializer.new(@customer.subscriptions), status: :ok
      end

      def create
        @customer.subscriptions.create!(subscription_params)
        render json: { success: 'Subscription added successfully' }, status: :created
      end

      private

      def subscription_params
        params[:active] = true
        params.require(:subscription).permit(:title, :price, :frequency, :customer_id, :tea_id, :active)
      end

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

      def render_error(error)
        render json: ErrorSerializer.user_error(error.message), status: :bad_request
      end
    end
  end
end