class NotifySubscribersJob < ApplicationJob
  queue_as :default

  def perform(answer)
    question = answer.question
    question.subscriptions.find_each do |subscription|
      NotifySubscribersAboutAnswersMailer.notify(subscription.user, answer).deliver_now
    end

  end
end
