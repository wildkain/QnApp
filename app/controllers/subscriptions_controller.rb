class SubscriptionsController < ApplicationController
  def create
    @subscription = current_user.subscriptions.create(question_id: params[:question_id] )
    respond_with(@subscription)
  end

  def destroy
    subscription = Subscription.find(params[:id])
    @question = Question.find(subscription.question_id)
    respond_with(subscription.destroy)
  end
end
