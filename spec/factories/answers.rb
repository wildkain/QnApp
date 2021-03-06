FactoryBot.define do
  factory :answer do
    sequence(:body) { |n| "AnswerBody #{n}" }
    question
    user
    best false
  end

  factory :invalid_answer, class: "Answer" do
    body nil
  end
end
