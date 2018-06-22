FactoryBot.define do
  factory :attachment do
    file { File.new("#{Rails.root}/spec/test_file.txt") }
  end
end
