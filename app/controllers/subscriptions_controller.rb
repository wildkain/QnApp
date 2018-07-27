class SubscriptionsController < ApplicationController
  before_action :authenticate_user!
  authorize_resource
  respond_to :js

  def create
    @subscription = current_user.subscriptions.create(question_id: params[:question_id] )
    respond_with(@subscription)
  end

  def destroy
    subscription = Subscription.find(params[:id])
    @question = subscription.question
    respond_with(subscription.destroy)
  end
end
