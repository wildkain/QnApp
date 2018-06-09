FactoryBot.define do
  factory :question do
    sequence(:title) { |n| "QuestionTitle #{n}" }
    sequence(:body)  { |n| "QuestionBody #{n}" }
    user
  end

  factory :invalid_question, class: "Question" do
    title nil
    body nil
  end

end
