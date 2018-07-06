FactoryBot.define do
  factory :comment do
    body "Just Comment"
    user nil
  end


  factory :invalid_comment, class: "Comment" do
    body nil
    user
  end
end
