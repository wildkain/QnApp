require 'rails_helper'


RSpec.describe User, type: :model do
  it { should have_many(:questions).dependent(:destroy)  }
  it { should have_many(:answers).dependent(:destroy)  }
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  let(:user) { create :user }
  let(:question) { create(:question, user: user) }
  let(:not_author_user) { create :user}
  let(:answer) { create(:answer, question: question, user: user) }


  context 'Check #author? for question' do
    it 'return true if user author of question' do
      expect(user.author?(question)).to eq true
    end

    it 'return false if user not author' do
      expect(not_author_user.author?(question)).to eq false
    end

  end

  context 'Check author of answer' do
    it 'return true if user author of answer' do
      expect(user.author?(answer)).to eq true
    end

    it 'return false if user not author' do
      expect(not_author_user.author?(answer)).to eq false
    end
  end
end
