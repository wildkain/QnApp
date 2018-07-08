require 'rails_helper'


RSpec.describe User, type: :model do
  it { should have_many(:questions).dependent(:destroy)  }
  it { should have_many(:answers).dependent(:destroy)  }
  it { should have_many(:comments) }
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  let(:user) { create :user }
  let(:question) { create(:question, user: user) }
  let(:not_author_user) { create :user}
  let(:answer) { create(:answer, question: question, user: user) }


  context 'Check #author? for question' do
    it 'author of question must be author ' do
      expect(user).to be_author(question)
    end

    it 'non-author must not be author of question' do
      expect(not_author_user).to_not be_author(question)
    end

  end

  context 'Check author of answer' do
    it 'author of answer must be author ' do
      expect(user).to be_author(answer)
    end

    it 'non-author must not be author of answer' do
      expect(not_author_user).to_not be_author(answer)
    end
  end
end
