module Api
  module V1
    class SubscriptionsController < ApplicationController
      rescue_from ActiveRecord::RecordInvalid,
                  Exceptions::InvalidRequest,
                  ActiveRecord::RecordNotFound,
                  with: :render_error
      before_action :find_customer, only: %i[index create update]
      before_action :check_subscription_status, only: :update

      def index
        render json: SubscriptionSerializer.new(@customer.subscriptions), status: :ok
      end

      def create
        @customer.subscriptions.create!(subscription_params)
        render json: { success: 'Subscription added successfully' }, status: :created
      end

      def update
        @subscription.cancel
        render json: SubscriptionSerializer.new(@subscription), status: 200
      end

      private

      def subscription_params
        params[:frequency] = params[:frequency].to_i if params[:frequency]
        params.permit(:title, :price, :frequency, :customer_id, :tea_id, :active)
      end

      def find_customer
        id = params[:customer_id]
        @customer = Customer.find_by(id: id)
        validate_customer
      end

      def validate_customer
        return if @customer

        if params[:customer_id]
          render json: ErrorSerializer.invalid_id('customer'), status: :bad_request
        else
          render json: ErrorSerializer.missing_parameter('customer_id'), status: :bad_request
        end
      end

      def render_error(error)
        render json: ErrorSerializer.user_error(error.message), status: :bad_request
      end

      def check_subscription_status
        @subscription = Subscription.find(params[:id])
        if @subscription.active == false
          raise Exceptions::InvalidRequest, 'Invalid request, subscription is already cancelled'
        elsif !@customer.subscriptions.include?(@subscription)
          raise Exceptions::InvalidRequest, 'Invalid request, subscription does not belong to customer_id'
        end
      end
    end
  end
end
