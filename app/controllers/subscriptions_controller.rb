class SubscriptionsController < ApplicationController
  def create
    logger.info "Params #{params}"
    @subscription = current_user.subscriptions.create(question_id: params[:question_id] )
  end

  def destroy
    subscription = Subscription.find(params[:id])
    @question = Question.find(subscription.question_id)
    subscription.destroy
  end
end
