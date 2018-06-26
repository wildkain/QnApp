require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:attachments).dependent(:destroy) }
  it { should validate_presence_of :title }
  it { should validate_presence_of :body }
  it { should accept_nested_attributes_for :attachments }

  let(:user) {create :user}
  let(:another_user) { create :user }
  let(:question) { create :question }


  describe '#vote' do
    it 'change votes counter' do
      expect{ question.vote(user, 1) }.to change(Vote, :count).by 1
    end

    context  'vote must be correct' do
      before { @vote = question.vote(user, 1) }

      it 'chnge count' do
        expect(@vote.count).to eq 1
      end

      it 'have user reference' do
        expect(@vote.user_id).to eq user.id
      end

      it 'have reference to self' do
        expect(@vote.votable).to eq question
      end

    end
  end

  describe '#already_voted?' do

    let!(:vote) { create(:vote, :up, user: user, votable: question) }

    it 'return true if user already vote' do
      expect(question.already_voted?(user, 1)).to eq true
    end

    it 'return false if answer have not user vote' do
      expect(question.already_voted?(another_user, 1)).to eq false
    end
  end

  describe '#votes_sum' do
    let!(:another_user) { create :user }

    it 'return sum of all votes for question' do
      create(:vote, :up, user: user, votable: question)
      create(:vote, :up, user: another_user, votable: question)

      expect(question.votes_sum).to eq 2
    end
  end
end
