require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to(:question) }
  it {should validate_presence_of :body}
  it { should have_many(:attachments).dependent(:destroy) }
  it { should have_many(:votes).dependent(:destroy) }
  it { should accept_nested_attributes_for :attachments}
  let(:question) { create :question }
  let!(:best_answer) { create(:answer, best: true, question: question) }
  let!(:another_answer) { create :answer, question: question }
  let!(:user) {create :user}

  describe '#best!' do
    it 'set best answer' do
      another_answer.best!
      another_answer.reload

      expect(another_answer).to be_best
    end

    it 'make already best answer to not best' do
      another_answer.best!
      another_answer.reload
      best_answer.reload

      expect(best_answer).to_not be_best
    end
  end

  describe 'scope' do
    describe 'best_ordered' do
      it 'best answer first in collection' do
        another_answer.best!

        expect(question.answers.best_ordered.first).to eq another_answer
      end
    end
  end

  describe '#vote' do
    it 'change votes counter' do
      expect{ another_answer.vote(user, 1) }.to change(Vote, :count).by 1
    end

    context  'vote must be correct' do
      before { @vote = another_answer.vote(user, 1) }

      it 'chnge count' do
        expect(@vote.count).to eq 1
      end

      it 'have user reference' do
        expect(@vote.user_id).to eq user.id
      end

      it 'have reference to answer' do
        expect(@vote.votable).to eq another_answer
      end

    end
  end

  describe '#already_voted?' do
    let!(:another_user) { create :user}
    let!(:vote) { create(:vote, :up, user: user, votable: another_answer) }

    it 'return true if user already vote' do
      expect(another_answer.already_voted?(user, 1)).to eq true
    end

    it 'return false if answer have not user vote' do
      expect(another_answer.already_voted?(another_user, 1)).to eq false
    end
  end

  describe '#votes_sum' do
    let!(:another_user) { create :user }
    let!(:answer) { create(:answer, user: another_user, question: question) }

    it 'return sum of all votes for answer' do
      create(:vote, :up, user: user, votable: answer)
      create(:vote, :up, user: another_user, votable: answer)

      expect(answer.votes_sum).to eq 2
    end
  end

end
