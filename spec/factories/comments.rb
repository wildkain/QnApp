FactoryBot.define do
  factory :comment do
    sequence(:body) { |n| "Just Comment #{n}" }
    user
  end


  factory :invalid_comment, class: "Comment" do
    body nil
    user
  end
end
