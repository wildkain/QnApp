require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to(:question) }
  it {should validate_presence_of :body}

  let(:question) { create :question }
  let!(:best_answer) { create(:answer, best: true, question: question) }
  let!(:another_answer) { create :answer, question: question }

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

      expect(best_answer.best).to_not be_best
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

end
