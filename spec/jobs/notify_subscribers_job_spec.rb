require 'rails_helper'

RSpec.describe NotifySubscribersJob, type: :job do
  let!(:author_question) { create :user }
  let(:question) {create(:question, user: author_question)}
  let!(:answer) { create(:answer, question: question, user: author_question) }
  let(:users) { create_list(:user, 4) }

  it 'send new answer  to subscribed users' do
    users.each  { |user| Subscription.create(question: question, user: user) }

    question.subscriptions.find_each do |subscription|
      expect(NotifySubscribersAboutAnswersMailer).to receive(:notify).with(subscription.user, answer).and_call_original
    end
    NotifySubscribersJob.perform_now(answer)
  end
end
